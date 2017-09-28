# Prometheus Add-on
An add-on that will deploy [Prometheus](https://prometheus.io/) on the OpenShift cluster provided by [Minishift](https://github.com/minishift/minishift).

## Prerequisites

- Origin version >= 3.6.0
- A _cluster-admin_ user which is required to access Prometheus web UI.

_NOTE_: [`admin-user`](https://github.com/minishift/minishift/tree/master/addons/admin-user) add-on provides a way to create _admin_ user with _cluster-admin_ role

Verify that you have installed the add-on by following [general readme](../../README.adoc#download-use-community-addons).

## Deploy Prometheus
To deploy Prometheus do:

```
minishift addon apply prometheus --addon-env namespace=kube-system
```

## Use Prometheus

- Prometheus will be available at:

  ```
  $ minishift openshift service prometheus -n kube-system
  ```

  _NOTE_: There service is exposed though SSL, so use _https_ to access it.

- Login with cluster-admin user in OpenShift console during `Sign in with a Account` action.


## Delete Prometheus
Delete Prometheus with:

```
oc delete sa,clusterrolebinding,route,svc,secret,deployment,configmap -l app=prometheus -n <namespace> --as=system:admin
```
