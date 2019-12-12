# Deploying KubeVirt on OpenShift

* This addon provides an easy way to install [KubeVirt](https://kubevirt.io/) on [Minishift](https://github.com/minishift/minishift).
* Prerequisites:

 * [Installed and running](https://docs.openshift.org/latest/minishift/getting-started/installing.html) Minishift
 * [Installed](https://docs.openshift.org/latest/minishift/command-ref/minishift_oc-env.html) OpenShift CLI

## Start Minishift

* The deployment works with Minishift default resources - 2 CPUs and 2 GB RAM. Nevertheless we prefer to allocate more memory (as much as you'd need to run your VMs) available to KubeVirt. Start Minishift using following command to provide more RAM.

  ```shell
  $ minishift start --memory=8GB
  ```

## Add-on installation

* Clone this repository onto your local machine and then install the add-on via:

  ```shell
  $ minishift addons install <path_to_directory_containing_this_readme>
  ```

## Start KubeVirt

* Deploy all KubeVirt components.

  ```shell
  $ minishift addons apply kubevirt
  ```

## Variables

*KUBEVIRT_VERSION* is mandatory and must be set to one of the [KubeVirt available releases](https://github.com/kubevirt/kubevirt/releases), by default it's set to *v0.7.0-alpha.2*.

> **NOTE**: Due to issues on KubeVirt (e.g. [kubevirt/kubevirt#1196](https://github.com/kubevirt/kubevirt/issues/1196)) *KUBEVIRT_VERSION* is set to *v0.7.0-alpha.2* and it's not recommended to use a newer one until the issues are fixed.
