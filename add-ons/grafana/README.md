
# Grafana Add-on

This addon install grafana for metrics visualization

## Prerequisites

Start minishift with --metrics option and memory 4 GB or more

Run 'management-infra' addon as:

```
$ minishift addon install management-infra  
$ minishift addon apply management-infra
```

## Deploy grafana

To deploy grafana do:

```
$ minishift addon install grafana
$ minishift addon apply grafana --addon-env namespace=grafana
```

_NOTE_: namespace is a required environment variable for the add-on to run. Refer [addon-dynamic-variables](https://docs.okd.io/latest/minishift/using/addons.html#addon-dynamic-variables) documentation.

## Use grafana
grafana will be available at:

```
$ minishift openshift service hawkular-grafana -n grafana
```

After connecting to grafana, you should log as user: admin, password: admin

Add a datasource with:
* Type: Hawkular
* Url: the url given by "oc get route hawkular-metrics -n openshift-infra -o jsonpath='https://{.spec.host}/hawkular/metrics'"
* Access: proxy
* Auth type: With Credentials
* Tenant: _system (or any namespace)
* Token: the result of "oc sa get-token management-admin -n management-infra --as=system:admin"

Then, you can get any dashboard.

An [example](cluster-metrics-per-namespace.json) is provided in this folder. When importing the dashboard, use the datasource created before.


## Delete grafana
Delete grafana with:

```
$ oc delete project -n grafana --as=system:admin
```
