# management-infra Add-on
An addon to create objects to support ManageIQ or CloudForms

NOTE: Requires OCP >= 3.6.0

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
