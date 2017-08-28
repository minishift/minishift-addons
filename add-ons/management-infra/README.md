# management-infra Add-on
An addon to create objects to support ManageIQ or CloudForms 

NOTE: Requires Origin >= 3.6.0

Verify you have installed these addons, by following the [general readme](../../Readme.adoc#download-and-use-community-add-ons).

## Deploy management-infra
To deploy management-infra do:

```
minishift addon apply management-infra
```

## Delete management-infra
Delete management-infra with:

```
oc delete project/management-infra clusterrole/management-infra-admin clusterrole/hawkular-metrics-admin --as=system:admin
```
