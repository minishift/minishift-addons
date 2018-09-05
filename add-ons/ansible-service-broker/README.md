Ansible Service Broker Addon
======================

This addon installs the [Ansible Service Broker](https://github.com/openshift/ansible-service-broker). The Ansible Service Broker
is an Open Service Broker designed to deploy [Ansible Playbook Bundles](https://github.com/ansibleplaybookbundle/ansible-playbook-bundle/) (hereafter referred to as APBs).

# Prerequisites

This addon is designed for an RBAC enabled OpenShift cluster of `>=3.9`. Minishift can be configured to
deploy 3.9 with the following command:

```
$ minishift config set openshift-version v3.9.0
```

Minishift must be deployed with the Service Catalog enabled

**NOTE**: Prior to minishift `v1.16.1`, minishift was installed with the Service
Catalog in a different way. These instructions are for minishift `>=v1.16.1`,
and it is strongly recommended that this version or greater is used.

The Service Catalog can be deployed by adding the `--service-catalog` when starting Minishift. The ability to pass extra flags during startup can be enabled by setting the _MINISHIFT_ENABLE_EXPERIMENTAL_ environmental variable as follows:

```
$ export MINISHIFT_ENABLE_EXPERIMENTAL=y
```

Configure minishift to deploy the centos iso:


```
$ minishift config set iso-url centos
```

Note: CentOS ISO is required for Fedora, CentOS, or RHEL hosts due to a [known issue](https://docs.okd.io/latest/minishift/troubleshooting/troubleshooting-misc.html#authentication-required-to-push-image) between the host's docker client and the default boot2docker iso.

Start Minishift with the `--service-catalog` extra flag. See the [OpenShift documentation](https://docs.okd.io/latest/minishift/using/experimental-features.html#enabling-experimental-oc-flags) for more info on `--extra-cluster-up` flags.

```
minishift start --extra-clusterup-flags "--service-catalog"
```


If you are planning on building or pushing to the minishift registry, be sure
to configure your shell using `eval $(minishift docker-env)`. This configures your environment
so that the apb tool can use the minishift registry. [See minishift documentation for more details](https://docs.okd.io/latest/minishift/openshift/openshift-docker-registry.html).

# Deploy the Ansible Service Broker

1. Make sure this repository is cloned to the local machine
2. Install the addon


```
$ minishift addons install <path_to_addon>
```

## Addon Variables

To customize the deployment of the Ansible Service Broker, the following variables can be applied to the execution:

|Name|Description|Default Value|
|----|-----------|-------------|
|`BROKER_REPO_TAG`|Tag used to specify the broker's template in the upstream asb repo|`ansible-service-broker-1.1.6-1`|
|`APBTOOLS_REPO_TAG`|Tag used to specify the apb tooling permission template in the upstream apb repo|`apb-1.1.6-1`|
|`DOCKERHUB_ORG`|Organization to query for Ansible Playbook Bundles in DockerHub|`ansibleplaybookbundle`|

Variables can be specified by adding `--addon-env <key=value>` when the addon is being invoked (`minishift start` or `minishift addons apply`)

## Apply the Addon

To apply the addon to a running instance of Minishift, execute the following command:

```
$ minishift addons apply ansible-service-broker
```

To enable the addon each time Minishift starts, execute the following command:

```
$ minishift addons enable ansible-service-broker
```

## Remove the Addon

To remove all of the deployed components, execute the following command

```
$ minishift addons remove ansible-service-broker
```

## Uninstall the addon

To uninstall the addon, execute the following command

```
$ minishift addons uninstall ansible-service-broker
```
