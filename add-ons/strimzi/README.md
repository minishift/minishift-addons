# Deploying Strimzi on OpenShift

This addon provides an easy way to install an Apache Kafka cluster, using [Strimzi](http://strimzi.io/) on [Minishift](https://github.com/minishift/minishift).

Prerequisites:

 * [Installed and running](https://docs.okd.io/latest/minishift/getting-started/installing.html) Minishift
 * [Installed](https://docs.okd.io/latest/minishift/command-ref/minishift_oc-env.html) OpenShift CLI

## Start Minishift
The deployment works with Minishift default resources - 2 CPUs and 4 GB RAM.
```
    $ minishift start
```

## Add-on installation
Clone this repository onto your local machine and then install the add-on via:
```
    $ minishift addons install <path_to_directory_containing_this_readme>
```

## Strimzi start
Deploy the Apache Kafka cluster, as a `cluster-admin` user:

```
oc login -u system:admin
...
minishift addon apply strimzi -a STRIMZI_VERSION=0.8.2 -a PROJECT=myproject
```

After a while all parts should be up and running, you can monitor the progress:

```
oc get pods -w
```

## Supported parameters
* `STRIMZI_VERSION` - the verson of Strimzi to be used (only released versions are supported)
* `PROJECT` - the name of the project to which Strimzi is deployed

## Strimzi Documentation
To learn more about Strimzi, read the [Strimzi documentation](http://strimzi.io/).
