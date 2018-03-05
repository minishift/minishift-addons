# Helm Add-on

Don't forget to read the [general readme](../../README.adoc#download-and-use-community-add-ons).

Tiller is the server side part of helm. You can check how to installs kubernetes helm in this [link](https://github.com/kubernetes/helm).

**NOTE** Please check in the [version](version) file to confirm the current release is compatible with the helm client and tiller server.

Before install helm into minishift please check if your minishift was started with defaults installed and admin-user enabled:

```
$ minishift addons install --defaults
Default add-ons 'anyuid, admin-user, xpaas, registry-route' installed

$ minishift addons enable admin-user
Add-on 'admin-user' enabled
```

After configured your minishift you can start using, for example:

```
$ minishift start --profile minishift --disk-size 40gb --memory 4096mb
```

The options above are not mandatory but show how you can define memory and disk for your local deployments.


## Deploy and install helm tiller
To deploy tiller on Minishift or OpenShift, apply this addon:

```
$ minishift addons install helm
$ minishift addons apply helm
```


## Discover tiller host
Get `oc`, `helm_host`(tiller) and `minishift` by adding this new variable into ~/.bashrc

```
eval "$(minishift oc-env)"
export HELM_HOST="$(minishift ip):$(oc get svc/tiller -o jsonpath='{.spec.ports[0].nodePort}' -n kube-system --as=system:admin)"
export MINISHIFT_ADMIN_CONTEXT="default/$(oc config view -o jsonpath='{.contexts[?(@.name=="minishift")].context.cluster}')/system:admin"
```

After added these new variables into ~/.bashrc can read it:

```
$ source ~/.bashrc
```


## Use helm with minishift

Once helm tiller has been deployed into minishift, you should configure your local helm instance to talk to this host.

To use helm, provide the minishift host to your helm config or to any helm command:

```
$ helm init -c
```

or

```
$ helm <operation>
```

Search for an application:

```
  helm search
```


And now deploy an application

```
$ helm install <app>
```

_NOTE_: Minishift admin context can be skipped if selected by default


## Delete tiller
If you want to delete tiller, just do:

```
$ oc delete sa/helm deployment/tiller-deploy svc/tiller -n kube-system --as=system:admin
```
