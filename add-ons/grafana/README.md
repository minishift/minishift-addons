# Grafana Add-on
An addon that will deploy grafana with hawkular and prometheus datasources.
It requires to connect to hawkular-metrics, provided by management-infra addon, and metrics should be enabled with --metrics on start up.

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
oc delete oc delete project -n <namespace> --as=system:admin
```
