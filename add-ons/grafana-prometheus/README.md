# Grafana Add-on

This addon installs grafana for metrics visualization from prometheus

## Prerequisites

The prometheus addon is required

```
minishift addon install prometheus-3.7
minishift addon apply prometheus-3.7 --addon-env namespace=kube-system
```

## Deploy grafana

To deploy grafana do:

```
minishift addon apply grafana --addon-env namespace=grafana
~/.minishift/addons/grafana-prometheus/setup-grafana.sh grafana
```

_NOTE_: namespace is a required environment variable for the add-on to run. Refer [addon-dynamic-variables](https://docs.openshift.org/latest/minishift/using/addons.html#addon-dynamic-variables) documentation.

## Use grafana
grafana will be available at:

```
minishift openshift service grafana-ocp -n grafana
```

After connecting to grafana, you should log as user: admin, password: admin

## Delete grafana
Delete grafana with:

```
oc delete project -n grafana --as=system:admin
```
