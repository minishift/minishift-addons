# Cockpit Add-on
An addon to install [cockpit](http://cockpit-project.org/).

Verify you have installed these addons, by following the [general readme](../../README.adoc#download-and-use-community-add-ons).

## Deploy cockpit
To deploy cockpit

```
$ minishift addon apply cockpit
```

## Use cockpit
Find cockpit console at the following URL:

```
$ minishift openshift service openshift-cockpit -n cockpit
```

You will need to log in with same user and creadentials as to OpenShift

## Delete cockpit
To delete cockpit, just do:

```
$ oc delete oauthclients/cockpit-oauth-client project/cockpit --as=system:admin
```
