# Prometheus Add-on
An addon that will deploy Prometheus, Node-Exporter and AlertManager.

NOTE: Requires Origin >= 3.7.0-rc.0

Verify you have installed these addons, by following the [general readme](../../README.adoc#download-and-use-community-add-ons).

## Deploy prometheus
To deploy prometheus do:

```
minishift addon apply prometheus --addon-env prometheus_namespace=kube-system
```

_NOTE_: You should provide the namespace where it will be installed with the addon-env prometheus_namespace, like this:

## Use prometheus
Prometheus will be available at:

```
minishift openshift service prometheus -n <prometheus_namespace>
```

_NOTE_: There service is exposed though SSL, so use https to access it.

## Delete prometheus
Delete prometheus with:

```
minishift addon remove prometheus-3.7
oc delete sa,clusterrolebinding,route,svc,secret,deployment,configmap,daemonset,statefulset -l 'app in (prometheus,prometheus-node-exporter)' -n <prometheus_namespace> --as=system:admin
```
