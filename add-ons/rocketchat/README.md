
# Rocket.Chat Add-on

This addon install rocket.chat so that developer teams can have an privately-hosted http chat room  

## Prerequisites

Start minishift with Openshift >= v3.7 and memory 4 GB or more


```
git clone https://github.com/minishift/minishift-addon
cd minishift-addon/add-ons/rocketchat && export ROCKETCHAT=$pwd
minishift addon install $ROCKETCHAT
```

## Deploy Rocket.Chat

To deploy rocket chat do:

```
$ minishift addon apply rocketchat --addon-env namespace=rocketchat
```

_NOTE_: namespace is a required environment variable for the add-on to run. Refer [addon-dynamic-variables](https://docs.openshift.org/latest/minishift/using/addons.html#addon-dynamic-variables) documentation.

## Use Rocket.Chat
rocket chat will be available at:

```
$ minishift openshift service rocket-chat -n rocketchat
```

## Uninstall rocketchat
Delete rocketchat with:

```
$ oc delete project -n rocketchat --as=system:admin
```
