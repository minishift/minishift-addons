# Kubernetes dashboard Add-on
An addon to install [kubernetes-dashboard](https://github.com/kubernetes/dashboard)

Verify you have installed these addons, by following the [general readme](../../README.adoc#download-and-use-community-add-ons).

## Deploy kube-dashboard
To deploy kube-dashboard do

```
$ minishift addon apply kube-dashboard
```

## Use kube-dashboard
To access it:

```
$ minishift openshift service dashboard -n kube-dashboard
```

_NOTE_: Kube-dashboard is deployed with cluster-admin pivileges, so if you use this addon, anyone accesing kube-dashboard will be able to do anything on this cluster

## Delete kube-dashboard
To delete kube-dashboard do:

```
$ oc delete project/kube-dashboard --as=system:admin
```
