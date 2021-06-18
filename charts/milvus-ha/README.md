# Milvus Helm Chart

For more information about installing and using Helm, see the [Helm Docs](https://helm.sh/docs/). For a quick introduction to Charts, see the [Chart Guide](https://helm.sh/docs/topics/charts/).

To install Milvus, refer to [Milvus installation](https://milvus.io/docs/guides/get_started/install_milvus/install_milvus.md).

## Introduction
This chart bootstraps Milvus deployment on a Kubernetes cluster using the Helm package manager.

## Prerequisites

- Kubernetes 1.14+
- Helm >= 3.0.0

## Installing the Chart

1. Add the stable repository
```bash
$ helm repo add milvus https://milvus-io.github.io/milvus-helm/
```

2. Update charts repositories
```
$ helm repo update
```

3. Install Helm package

To install the chart with the release name `my-release`:

```bash
# Helm v3.x
$ helm upgrade --install my-release milvus/milvus
```

> **Tip**: To list all releases, using `helm list`.

### Deploying Milvus with cluster enabled

```bash
# Helm v3.x
$ helm upgrade --install --set standalone.enabled=false my-release  .
```
## Uninstall the Chart

```bash
# Helm v3.x
$ helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

### Milvus Server Configuration

The following table lists the configurable parameters of the Milvus chart and their default values.

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `image.all.repository`                    |                                               | `milvusdb/milvus`                                       |
| `image.all.tag`                           |                                               | `latest`                                                |
| `image.all.pullPolicy`                    |                                               | `IfNotPresent`                                          |
| `image.all.pullSecrets`                   |                                               | `{}`                                                    |
| `service.type`                            |                                               | `ClusterIP`                                             |
| `service.port`                            |                                               | `19530`                                                 |
| `service.nodePort`                        |                                               | `unset`                                                 |
| `service.annotations`                     |                                               | `{}`                                                    |
| `service.labels`                          |                                               | `{}`                                                    |
| `service.loadBalancerIP`                  |                                               | `unset`                                                 |
| `service.loadBalancerSourceRanges`        |                                               | `[]`                                                    |
| `service.externalIPs`                     |                                               | `[]`                                                    |
| `ingress.enabled`                         |                                               | `false`                                                 |
| `ingress.annotations`                     |                                               | `{}`                                                    |
| `ingress.labels`                          |                                               | `{}`                                                    |
| `ingress.hosts`                           |                                               | `[]`                                                    |
| `ingress.tls`                             |                                               | `[]`                                                    |
| `log.level`                               | log level                                     | `debug`                                                 |
| `log.file.maxSize`                        |                                               | `300`                                                   |
| `log.file.maxAge`                         |                                               | `10`                                                    |
| `log.file.maxBackups`                     |                                               | `20`                                                    |
| `log.format`                              |                                               | `text`                                                  |

### Milvus Standalone Deployment Configuration

The following table lists the configurable parameters of the Milvus chart and their default values.

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `standalone.enabled`                      |                                               | `true`                                                  |
| `standalone.replicas`                     |                                               | `1`                                                     |
| `standalone.resources`                    |                                               | `{}`                                                    |
| `standalone.nodeSelector`                 |                                               | `{}`                                                    |
| `standalone.affinity`                     |                                               | `{}`                                                    |
| `standalone.tolerations`                  |                                               | `[]`                                                    |
| `standalone.extraEnv`                     |                                               | `[]`                                                    |
