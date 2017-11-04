# OpenShift Workshop Add-on
An addon to install an [OpenShift Workshop](https://github.com/osevg/workshop-content)

Verify you have installed these addons, by following the [general readme](../../README.adoc#download-and-use-community-add-ons).

## Deploy workshop
To deploy this workshop do:

```
$ minishift addon apply workshop
```

## Use workshop
To access it:

````
$ minishift openshift service workshop -n workshop
````

## Delete workshop
To delete the workshop do:

```
$ oc delete project/workshop --as=system:admin
```
