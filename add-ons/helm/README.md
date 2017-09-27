# Helm Add-on
Installs [kubernetes helm](https://github.com/kubernetes/helm) tiller into minishift. Tiller is the server side part of helm.

Verify you have installed these addons, by following the [general readme](../../README.adoc#download-and-use-community-add-ons).

## Deploy helm tiller
To deploy tiller on OpenShift, apply this addon:

```
$ minishift addon apply helm
```

## Discover tiller host
Get Tiller host URL by running these commands in the shell:

```
$ export TILLER_HOST="${minishift ip}:$(oc get svc/tiller -o jsonpath='{.spec.ports[0].nodePort}' -n kube-system --as=system:admin)"
```

Minishift's admin context can be used like this:

```
$ export MINISHIFT_ADMIN_CONTEXT="default/$(oc config view -o jsonpath='{.contexts[?(@.name=="minishift")].context.cluster}')/system:admin"
```

## Use helm with minishift
Once helm tiller has been deployed into minishift, you should configure your local helm instance to talk to this host.

To use helm, provide the minishift host to your helm config or to any helm command:

```
$ helm init --host $TILLER_HOST -c
```

or

```
$ helm <operation> --host $TILLER_HOST
```

Search for an application:

```
  helm search
```


And now deploy an application

```
$ helm install <app> --host $TILLER_HOST --kube-context $MINISHIFT_ADMIN_CONTEXT
```

_NOTE_: Minishift admin context can be skipped if selected by default

## Delete tiller
If you want to delete tiller, just do:

```
$ oc delete sa/helm deployment/tiller-deploy svc/tiller -n kube-system --as=system:admin
```
