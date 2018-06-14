# OpenWhisk Add-on

This is an add-on to install OpenWhisk FaaS

Verify you have installed these addons, by following the general [readme](https://github.com/minishift/minishift-addons/blob/master/README.adoc#download-and-use-community-add-ons).

As explained in the readme, clone the repository to get addons to your workstation.

## Prerequisites

Set up minishift with the following configuration and start

```
 minishift profile set openwhisk-test
 minishift config set memory 8GB
 minishift config set cpus 3
 minishift addon enable admin-user
 minishift addon enable anyuid
 minishift start
```

Once minishift starts up run the following command to turn on promiscous mode in the minishift VM.

```
minishift ssh -- sudo ip link set docker0 promisc on
```

Also patch the admin config policy.

```
minishift openshift config set --patch \
        '{"admissionConfig":
            {"pluginConfig":
                {"openshift.io/ImagePolicy":
                    {"configuration":
                        {"apiVersion": "v1",
                         "kind": "ImagePolicyConfig",
                         "resolveImages": "AttemptRewrite"}}}}}'
```


## Install Add-on

Run the following command after you start minishift

```
$ minishift addon install <path_to_directory_containing_this_readme>
```

## Deploy Add-on

To deploy OpenWhisk 

```
$ minishift addons apply openwhisk 
```

This creates a project with name `openwhisk` and spins up all OpenWhisk components in that project.  

**NOTE:** It takes a long time to pull all these images and for the pods to come up. Be patient.

Post deployment you can download and use [OpenWhisk CLI](https://github.com/apache/incubator-openwhisk-cli/releases/) and use `wsk` command line.

Also you will need to configure auth secret to invoke `wsk` commands by running the following:

```
wsk property set --auth $(oc get secret whisk.auth -o yaml | grep "system:" | awk '{print $2}' | base64 --decode) --apihost $(oc get route/openwhisk --template="{{.spec.host}}")
```  

## Remove Add-on

To remove add-on simply run

```
$ minishift addons remove openwhisk
```

## Uninstall Add-on
To uninstall add-on run

```
$ minishift addons uninstall openwhisk
```


