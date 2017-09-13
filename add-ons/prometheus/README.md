# Prometheus Add-on
An addon that will deploy Prometheus. 

NOTE: Requires Origin >= 3.6.0-rc.0

Verify you have installed these addons, by following the [general readme](../../README.adoc#download-and-use-community-add-ons).

## Deploy prometheus
To deploy prometheus do:

```
minishift addon apply prometheus --addon-env namespace=kube-system
```

_NOTE_: You should provide the namespace where it will be installed with the addon-env namespace, like this:

## Use prometheus
Prometheus will be available at:

```
$ minishift openshift service prometheus -n <namespace>
```

_NOTE_: There service is exposed though SSL, so use https to access it.

## Delete prometheus
Delete prometheus with:

```
oc delete sa,clusterrolebinding,route,svc,secret,deployment,configmap -l app=prometheus -n <namespace> --as=system:admin
```