# Eclipse Che Addon

This addon create Eclipse Che templates, image streams and a project running Che in Minishift. In short this helps in setting up Eclipse Che 
on Minishift inline with [Deploy Che on Minishift](https://www.eclipse.org/che/docs/setup/openshift/index.html#deploy-che-on-minishift)

<!-- MarkdownTOC -->

- [Using the Eclipse Che Add-on](#using-the-eclipse-che-add-on)
	- [Start Minishift](#start-minishift)
	- [Install add-on](#install-add-on)
	- [Apply add-on](#apply-add-on)
	- [Remove add-on](#remove-add-on)
	- [Uninstall add-on](#uninstall-add-on)

<!-- /MarkdownTOC -->

This addon provides an easy way to install Eclipse Che on MiniShift.

Eclipse Che provides a complete cloud IDE.

<a name="using-the-eclipse-che-add-on"></a>
## Using the Eclipse Che Add-on

The best way of using this add-on is via the [`minishift add-ons apply`](https://docs.openshift.org/latest/minishift/command-ref/minishift_addons_apply.html) command which is outlined in the following paragraphs.

<a name="start-minishift"></a>
### Start Minishift

Start Minishift using something like this:

    $ minishift start

However, as default memory is set to 2GB and a che-server takes about 700MB memory and a default stack workspace can reach 2GB,
we recommand to start Minishift with at least 5GB:

    $ minishift start --memory=5GB 

<a name="install-add-on"></a>
### Install add-on
Clone this repository onto your local machine and then install the add-on via:

    $ minishift addons install <path_to_directory_containing_this_readme>
    $ minishift addons enable che


`enable` will setup Eclipse Che when you start Minishift the next time.

<a name="apply-add-on"></a>
### Apply add-on
If Minishift is already started and che addon is installed. It is possible to deploy che without restarting Minishift:

#### Deploy Che v5 (stable)

```bash
$ minishift addons apply --addon-env CHE_HOST_PREFIX="" che
```

#### Deploy Che v6 (unstable)

```bash
$ minishift addons apply \
    --addon-env CHE_DOCKER_IMAGE_TAG=nightly \
    --addon-env OPENSHIFT_TOKEN=$(oc whoami -t) \
    che
```

#### Deploy a local che-server image

In order to deploy a local che-server image we to push that image to the `che-server` Image Stream that is created by the addon. For example, if you have set `CHE_DOCKER_IMAGE_TAG=nightly` you will need to update the `che-server:nightly` Image Stream:

```bash
LOCAL_DOCKER_IMAGE=eclipse/che-server:local
IMAGE_STREAM=nightly
docker login -u developer -p $(oc whoami -t) $(minishift openshift registry)
docker tag ${LOCAL_DOCKER_IMAGE} $(minishift openshift registry)/openshift/che-server:${IMAGE_STREAM}
docker push $(minishift openshift registry)/openshift/che-server:${IMAGE_STREAM}
```

#### Addon Variables

To customize the deployment of the Che server, the following variables can be applied to the execution:

|Name|Description|Default Value|
|----|-----------|-------------|
|`NAMESPACE`|The OpenShift project where Che service will be deployed|`che-mini`|
|`CHE_DOCKER_IMAGE_TAG`|The docker image tag to be used for che. Accepted values are `latest` and `nightly`|`latest`|
|`GITHUB_CLIENT_ID`|GitHub client ID to be used in Che workspaces|`changeme`|
|`GITHUB_CLIENT_SECRET`|GitHub client secred to be used in Che workspaces|`changeme`|
|`OPENSHIFT_TOKEN`|For Che v6 only. The token to create workspace resources (pods, services, routes, etc...)|`changeme`|
|`CHE_HOST_PREFIX`|For Che v5 only. Set it to the empty string to run Che v5|`che`|

Variables can be specified by adding `--addon-env <key=value>` when the addon is being invoked (either by `minishift start` or `minishift addons apply`).

<a name="remove-add-on"></a>
### Remove add-on
To remove all created template and che project:

    $ minishift addons remove \
        --addon-env OPENSHIFT_TOKEN="" \
        --addon-env CHE_DOCKER_IMAGE_TAG="" \
        --addon-env CHE_HOST_PREFIX="" \
        --addon-env GITHUB_CLIENT_ID="" \
        --addon-env GITHUB_CLIENT_SECRET="" \
        --addon-env NAMESPACE=mini-che che

<a name="uninstall-add-on"></a>
### Uninstall add-on
To uninstall the addon from the addon list:

    $ minishift addons uninstall che

