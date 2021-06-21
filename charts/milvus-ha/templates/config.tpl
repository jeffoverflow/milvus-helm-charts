{{- define "milvus-ha.config" -}}
# Copyright (C) 2019-2021 Zilliz. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance
# with the License. You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License
# is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied. See the License for the specific language governing permissions and limitations under the License.

etcd:
{{- if .Values.externalEtcd.enabled }}
  endpoints:
  {{- range .Values.externalEtcd.endpoints }}
    - {{ . }}
  {{- end }}
{{- else }}
  endpoints:
    - {{ .Release.Name }}-{{ .Values.etcd.name }}:{{ .Values.etcd.service.port }}
{{- end }}
  rootPath: by-dev
  metaSubPath: meta # metaRootPath = rootPath + '/' + metaSubPath
  kvSubPath: kv # kvRootPath = rootPath + '/' + kvSubPath

minio:
{{- if .Values.externalS3.enabled }}
  address: {{ .Values.externalS3.host }}
  port: {{ .Values.externalS3.port }}
  accessKeyID: {{ .Values.externalS3.accessKey }}
  secretAccessKey: {{ .Values.externalS3.secretKey }}
{{- else }}
  address: {{ .Release.Name }}-{{ .Values.minio.name }}
  port: {{ .Values.minio.service.port }}
  accessKeyID: {{ .Values.minio.accessKey }}
  secretAccessKey: {{ .Values.minio.secretKey }}
{{- end }}
  useSSL: false
  bucketName: "a-bucket"

pulsar:
{{- if .Values.externalPulsar.enabled }}
  address: {{ .Values.externalPulsar.host }}
  port: {{ .Values.externalPulsar.port }}
{{- else if .Values.pulsar.enabled }}
  address: {{ .Release.Name }}-{{ .Values.pulsar.name }}-proxy
  {{- $httpPort := "" -}}
  {{- $httpsPort := "" -}}
  {{- range .Values.pulsar.proxy.service.ports }}
  {{- if eq .name "pulsar" }}
  {{- $httpPort = .port -}}
  {{- else if eq .name "pulsarssl" }}
  {{- $httpsPort = .port -}}
  {{- end }}
  {{- end }}
  port: {{ $httpsPort | default $httpPort }}
{{- else }}
  address: {{ template "milvus-ha.pulsar.fullname" . }}
  port: {{ .Values.pulsarStandalone.service.port }}
{{- end }}

master:
{{- if .Values.cluster.enabled }}
  address: {{ template "milvus-ha.rootcoord.fullname" . }}
{{- else }}
  address: localhost
{{- end }}
  port: {{ .Values.rootCoordinator.service.port }}

proxyNode:
  port: 19530

queryService:
{{- if .Values.cluster.enabled }}
  address: {{ template "milvus-ha.querycoord.fullname" . }}
{{- else }}
  address: localhost
{{- end }}
  port: {{ .Values.queryCoordinator.service.port }}

queryNode:
  gracefulTime: 5000 #ms
  port: 21123

indexService:
{{- if .Values.cluster.enabled }}
  address: {{ template "milvus-ha.indexcoord.fullname" . }}
{{- else }}
  address: localhost
{{- end }}
  port: {{ .Values.indexCoordinator.service.port }}

indexNode:
  port: 21121

dataService:
{{- if .Values.cluster.enabled }}
  address: {{ template "milvus-ha.datacoord.fullname" . }}
{{- else }}
  address: localhost
{{- end }}
  port: {{ .Values.dataCoordinator.service.port }}

dataNode:
  port: 21124

log:
  level: {{ .Values.log.level }}
  file:
{{- if .Values.logsPersistence.enabled }}
    rootPath: {{ .Values.logsPersistence.mountPath }}
{{- else }}
    rootPath: ""
{{- end }}
    maxSize: {{ .Values.log.file.maxSize }}
    maxAge: {{ .Values.log.file.maxAge }}
    maxBackups: {{ .Values.log.file.maxBackups }}
  dev: {{ .Values.log.dev }}
  format: {{ .Values.log.format }}

{{- end }}
