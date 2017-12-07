Ansible Service Broker Addon
======================

This addon installs the [Ansible Service Broker](https://github.com/openshift/ansible-service-broker)

# Prerequisites

Minishift/CDK must be deployed with the Service Catalog enabled

The Service Catalog can be deployed by adding the `--service-catalog` when starting Minishift. The ability to pass extra flags during startup can be enabled by setting the _MINISHIFT_ENABLE_EXPERIMENTAL_ environmental variable as follows:

```
$ export MINISHIFT_ENABLE_EXPERIMENTAL=y
```

Start Minishift with the `--service-catalog` flag

```
$ minishift start --service-catalog
```

# Deploy the Ansible Service Broker

1. Make sure this repository is cloned to the local machine
2. Install the addon


        $ minishift addons install <path_to_addon>
  

## Addon Variables

To customize the deployment of the Ansible Service Broker, the following variables can be applied to the execution:

|Name|Description|Default Value|
|----|-----------|-------------|
|`DOCKERHUB_USER`|Username to authenticate to DockerHub|`changeme`|
|`DOCKERHUB_PASS`|Password to authenticate to DockerHub|`changeme`|
|`DOCKERHUB_ORG`|Organization to query for Ansible Playbook Bundles in DockerHub|`ansibleplaybookbundle`|
|`BROKER_KIND`|Kubernetes API Kind|`Broker`|
|`SVC_CAT_API_VER`|Kubernetes API Version|`servicecatalog.k8s.io/v1alpha1`|
|`BROKER_AUTH`|Broker Authentication|`{"basicAuthSecret":{"namespace":"ansible-service-broker","name":"asb-auth-secret"}}`|
|`ENABLE_BASIC_AUTH`|Enable Basic Authentication within the Broker|`true`|

Variables can be specified by adding `--addon-env <key=value>` when the addon is being invoked (`minishift start` or `minishift addons apply`)

## Apply the Addon

* To apply the addon to a running instance of Minishift, execute the following command:

        $ minishift addons apply ansible-service-broker
* To enable the addon each time Minishift starts, execute the following command:

        $ minishift addons enable ansible-service-broker

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