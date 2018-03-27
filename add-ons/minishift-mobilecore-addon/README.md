# Minishift Mobile Core Add-on

## Set up
[Install minishift](https://docs.openshift.org/latest/minishift/getting-started/installing.html)  
[Install OC](https://docs.openshift.org/latest/cli_reference/get_started_cli.html#installing-the-cli)

MiniShift needs to be at least 1.11.0, check it using the following command:
```
$ minishift version
minishift v1.11.0+4459917
```

Enable minishift experimental addons:
```
export MINISHIFT_ENABLE_EXPERIMENTAL=y
```

After Cloning this repo it will need to be added to the minishift addons catalog, this cannot be done from inside the directory, add it like so:
```
cd ..
minishift addons install -f minishift-mobilecore-addon/
minishift addons enable minishift-mobilecore-addon
```

A few config values are required for this addon to function, as follows:
```
export DOCKERHUB_USERNAME=<docker hub username>
export DOCKERHUB_PASSWORD=<docker hub password>
minishift config set addon-env DOCKERHUB_USERNAME=${DOCKERHUB_USERNAME},DOCKERHUB_PASSWORD="${DOCKERHUB_PASSWORD}"
```

### Custom Values
You may also want to change some other values for this addon, which are all added to the above addon-env CSV in the same way, simply append them to the end of the list. Here are the options:
- DOCKERHUB_ORG: defaults to 'aerogearcatalog', this is where the ASB looks for APBs.
- CORE_REPO: defaults to 'aerogear', this is the mobile-core repo to install (i.e. https://github.com/CORE_REPO/mobile-core.git).
- CORE_BRANCH defaults to 'master' this is the branch in the the CORE_REPO to install.

## Configure MiniShift
Although the default MiniShift will function just fine, for the best results, it is best to configure MiniShift to start with extra CPUs and RAM, this can be done with the following commands:
```
minishift config set cpus 4
minishift config set memory 4096
```

## Starting MiniShift with Mobile Core enabled
MiniShift must be both stopped and deleted for this to come up smoothly:
```
minishift stop
minishift delete
```

Create a new MiniShift cluster with service catalog and the mobilecore with the following command:
```
minishift start --openshift-version 3.7.0 --service-catalog
```

If you did not enable the addon, you will need to apply it manually:
```
minishift addons apply minishift-mobilecore-addon
```

## Troubleshooting

### Service Catalog Flag is not Recognised
This is an error output by MiniShift when it is running without the `MINISHIFT_ENABLE_EXPERIMENTAL` environment variable set to 'y'. To correct this run the following in your current shell:
```
export MINISHIFT_ENABLE_EXPERIMENTAL=y
```

### Mobile Tab not Present in the Catalog
This can have 2 causes:

#### The Ansible Service Broker Is Not Running.
To check if this is the case, login to your MiniShift cluster as admin:
```
oc login -u system:admin
```

And check if the asb pod is running correctly in the `ansible-service-broker` namespace:
```
oc get pods -n ansible-service-broker
```

You should see output like:
```
NAME               READY     STATUS    RESTARTS   AGE
asb-1-8n4b6        1/1       Running   0          46m
asb-etcd-1-ptzmp   1/1       Running   0          46m
```

If the asb pods are not running you can correct them by running either of:
```
oc rollout latest asb
oc rollout latest asb-etcd
```

This should correct the issue, if it doesn't then go to the "If All Else Fails" section below.

#### The Ansible Service Broker Cannot Find the Mobile APBs
This is most likely caused by a misconfiguration of the docker credentials or orgaisation name, see the section "APBs Not Showing in Catalog" for instructions on how to correct this issue.

### APBs Not Showing in Catalog
This is usually because incorrect values have been entered for the DOCKERHUB_USER, DOCKERHUB_PASSWORD or DOCKERHUB_ORG.

You can check the currently used values for these by running:
```
minishift config get addon-env
```

If these values are incorrect then once you have corrected them. They will not immediately take effect until you have run the following commands:
```
minishift stop
minishift delete
minishift start --openshift-version 3.7.0 --service-catalog
```

### Errors When Stopping or Deleting MiniShift
Check the MiniShift documentation for specific results, but this is generally caused by a problems in the MiniShift config directory (which defaults to `~/.minishift`). If there are MiniShift profiles that you care about keeping, then you can try and work around this issue by correcting the permissions problems. 

This can be caused if you have tried to execute `minishift delete` before executing `minishift stop`. In that case you can try running `minishift stop` and retrying `minishift delete`. If this does not correct the issue, then the simplest solution is to destroy the MiniShift configuration directory and recreate it. Do that with the following commands:
```
sudo rm -rf ~/.minishift
minishift addons install -f /path/to/minishift-mobilecore-addon
minishift addons enable minishift-mobilecore-addon
```

### When All Else Fails
Generally most issues with this plugin can be resolved by doing a stop and delete, i.e.:
```
minishift stop
minishift delete
minishift start --openshift-version 3.7.0 --service-catalog
```

It is also possible that the addon-env config value is misconfigured, to confirm the values are correct you can review them by running:
```
minishift config get addon-env
```