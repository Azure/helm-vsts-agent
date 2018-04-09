## Introduction

[![Build Status](https://travis-ci.org/Azure/helm-vsts-agent.svg?branch=master)](https://travis-ci.org/Azure/helm-vsts-agent)

This chart bootstraps a [Visual Studio Team Services agent pool](https://github.com/Microsoft/vsts-agent) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites
 - Kubernetes 1.8+ or newer

## Configuration

The following tables lists the configurable parameters of the `vsts-agent` chart and their default values.

| Parameter                         | Description                           | Default                                                   |
| --------------------------------- | ------------------------------------- | --------------------------------------------------------- |
| `image.repository`                | vsts-agent image                      | `microsoft/vsts-agent`                                    |
| `image.tag`                       | Specify image tag                     | `latest`                                                  |
| `image.pullSecrets`               | Specify image pull secrets            | `nil` (does not add image pull secrets to deployed pods)  |
| `image.pullPolicy`                | Image pull policy                     | `Always`                                                  |
| `replicas`                        | Number of vsts-agent instaces started | `3`                                                       |
| `resources.disk`                  | Size of the disk attached to the agent| `50Gi`                                                    |
| `vstsAccount`                     | VSTS account name                     | `nil` (must be provided during installation)              |
| `vstsToken`                       | VSTS personal access token            | `nil` (must be provided during installation)              |
| `vstsPool`                        | VSTS agent pool name                  | `kubernetes-vsts-agents`                                  |
| `vstsAgentName`                   | VSTS agent name                       | `$HOSTNAME`                                               |
| `vstsWorkspace`                   | VSTS agent workspace                  | `/workspace`                                              |

## Configure your VSTS instance

Before starting the chart installation, you have to configure your VSTS instance as follows:

1. Create a personal access token with the authorized scope **Agent Pools(read, manage)**  following these [instructions](https://docs.microsoft.com/en-us/vsts/git/_shared/personal-access-tokens). You will have to provide later the base64 encoded value of this token to the `vstsToken` value of the chart.

2. Create a new queue and agent pool with the name `kubernetes-vsts-agents`. You can find more details [here](https://docs.microsoft.com/en-us/vsts/build-release/concepts/agents/pools-queues#creating-agent-pools-and-queues).

## Installing the Chart

The chart can be installed with the following command:

```bash
export VSTS_TOKEN=$(echo -n '<VSTS TOKEN>' | base64)

helm install --namespace <NAMESPACE> --set vstsToken=${VSTS_TOKEN} --set vstsAccount=<VSTS ACCOUNT> --set vstsPool=<VSTS POOL> -f values.yaml vsts-agent .
```

Your deployment should look like this if everything works fine:

```bash
kubectl get pods --namespace <NAMESPACE> 
NAME           READY     STATUS    RESTARTS   AGE
vsts-agent-0   1/1       Running   0          1m
vsts-agent-1   1/1       Running   0          1m
vsts-agent-2   1/1       Running   0          1m
```
## Upgrading a deployed Chart

A deployed chart can be upgraded as follows:

```bash
export VSTS_TOKEN=$(echo -n '<VSTS TOKEN>' | base64)

helm upgrade --timeout 900 --namespace <NAMESPACE> --set vstsToken=${VSTS_TOKEN} --set vstsAccount=<VSTS ACCOUNT> --set vstsPool=<VSTS POOL> -f values.yaml vsts-agent . --wait
```

This command will upgrade the exiting chart and wait until the deployment is completed.

## Uninstalling the Chart

The chart can be uninstalled/deleted as follows:

```bash
helm delete --purge vsts-agent
```

This command removes all the Kubernetes resources associated with the chart and deletes the helm release.

## Validate the Chart

You can validate the chart during development by using the `helm template` command.

```bash
helm template .
```

## Scale up the number of VSTS agents

The number of VSTS agents can be easily increased to `10` by using the following command:

```bash
kubectl scale --namespace <NAMESPACE> statefulset/vsts-agent --replicas 10
```
## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
