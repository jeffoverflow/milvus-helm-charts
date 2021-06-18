{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "milvus-ha.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "milvus-ha.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified standalone name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "milvus-ha.standalone.fullname" -}}
{{ template "milvus-ha.fullname" . }}-standalone
{{- end -}}

{{/*
Create a default fully qualified Root Coordinator name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "milvus-ha.rootcoord.fullname" -}}
{{ template "milvus-ha.fullname" . }}-rootcoord
{{- end -}}

{{/*
Create a default fully qualified Proxy name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "milvus-ha.proxy.fullname" -}}
{{ template "milvus-ha.fullname" . }}-proxy
{{- end -}}

{{/*
Create a default fully qualified Query Coordinator name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "milvus-ha.querycoord.fullname" -}}
{{ template "milvus-ha.fullname" . }}-querycoord
{{- end -}}

{{/*
Create a default fully qualified querynode name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "milvus-ha.querynode.fullname" -}}
{{ template "milvus-ha.fullname" . }}-querynode
{{- end -}}

{{/*
Create a default fully qualified Index Coordinator name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "milvus-ha.indexcoord.fullname" -}}
{{ template "milvus-ha.fullname" . }}-indexcoord
{{- end -}}

{{/*
Create a default fully qualified indexnode name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "milvus-ha.indexnode.fullname" -}}
{{ template "milvus-ha.fullname" . }}-indexnode
{{- end -}}

{{/*
Create a default fully qualified Data Coordinator name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "milvus-ha.datacoord.fullname" -}}
{{ template "milvus-ha.fullname" . }}-datacoord
{{- end -}}

{{/*
Create a default fully qualified datanode name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "milvus-ha.datanode.fullname" -}}
{{ template "milvus-ha.fullname" . }}-datanode
{{- end -}}

{{/*
Create a default fully qualified pulsar name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "milvus-ha.pulsar.fullname" -}}
{{ template "milvus-ha.fullname" . }}-pulsar
{{- end -}}

{{/* etcd endpoints */}}
{{- define "milvus-ha.etcd.endpoints" -}}
{{- if .Values.externalEtcd.enabled -}}
{{ join "," .Values.externalEtcd.endpoints }}
{{- else -}}
{{ .Release.Name }}-{{ .Values.etcd.name }}:{{ .Values.etcd.service.port }}
{{- end -}}
{{- end -}}

{{/* minio address */}}
{{- define "milvus-ha.minio.address" -}}
{{- if .Values.externalMinio.enabled -}}
{{ .Values.externalMinio.address }}:{{ .Values.externalMinio.port }}
{{- else -}}
{{ .Release.Name }}-{{ .Values.minio.name }}:{{ .Values.minio.service.port }}
{{- end -}}
{{- end -}}

{{/* pulsar address */}}
{{- define "milvus-ha.pulsar.address" -}}
{{- if .Values.externalPulsar.enabled }}
{{ .Values.externalPulsar.address }}:{{ .Values.externalPulsar.port }}
{{- else if .Values.pulsar.enabled }}
{{- $httpPort := "" -}}
{{- $httpsPort := "" -}}
{{- range .Values.pulsar.proxy.service.ports }}
{{- if eq .name "pulsar" }}
{{- $httpPort = .port -}}
{{- else if eq .name "pulsarssl" }}
{{- $httpsPort = .port -}}
{{- end }}
{{- end }}
{{ .Release.Name }}-{{ .Values.pulsar.name }}-proxy:{{ $httpsPort | default $httpPort }}
{{- else }}
{{ template "milvus-ha.pulsar.fullname" . }}:{{ .Values.pulsarStandalone.service.port }}
{{- end }}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "milvus-ha.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Helm required labels */}}
{{- define "milvus-ha.labels" -}}
helm.sh/chart: {{ include "milvus-ha.chart" . }}
{{ include "milvus-ha.matchLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/* matchLabels */}}
{{- define "milvus-ha.matchLabels" -}}
app.kubernetes.io/name: {{ include "milvus-ha.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
