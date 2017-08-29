# Grafana Add-on
An addon that will deploy grafana with hawkular and prometheus datasources.
It requires to connect to hawkular-metrics, provided by management-infra addon.

Verify you have installed these addons, by following the [general readme](../../Readme.adoc#download-and-use-community-add-ons).

## Deploy grafana
To deploy grafana do:

```
minishift addon apply grafana --addon-env namespace=grafana
```

_NOTE_: You should provide the namespace where it will be installed with the addon-env namespace.

## Use grafana
grafana will be available at:

```
$ minishift openshift service hawkular-grafana -n <namespace>
```

Add a datasource with:
* Type: Hawkular
* Url: the route given on "minishift openshift service hawkular-metrics -n openshift-infra" ended with /hawkular/metrics. Ex: https://hawkular-metrics-openshift-infra.192.168.99.100.nip.io/hawkular/metrics
* Access: proxy
* Auth type: With Credentials
* Tenant: _system (or any namespace)
* Token: the result of "oc sa get-token management-admin -n management-infra --as=system:admin"

Then, you can get any dashboard.

An example one in provided in this folder ()


## Delete grafana
Delete grafana with:

```
oc delete oc delete project -n <namespace> --as=system:admin
```