# Fabric8 Add-on

<!-- MarkdownTOC -->

- [Using the Fabric8 Add-on](#using-the-fabric8-add-on)
	- [Install add-on](#install-add-on)
	- [Start Minishift](#start-minishift)
	- [Setup GitHub OAuth client ID and secret](#setup-github-oauth-client-id-and-secret)
	- [Apply add-on](#apply-add-on)

<!-- /MarkdownTOC -->

This addon provides an easy way to install Fabric8 on MiniShift.

Fabric8 provides a complete developer platform for creating projects, editing them and performing full CI / CD for the entire developer life-cycle.

<a name="using-the-fabric8-add-on"></a>
## Using the Fabric8 Add-on

The best way of using this add-on is via the [`minishift add-ons apply`](https://docs.okd.io/latest/minishift/command-ref/minishift_addons_apply.html) command which is outlined in the following paragraphs.

<a name="install-add-on"></a>
### Install add-on

Clone this repository onto your local machine and then install the add-on via:

    $ minishift addons install <path_to_directory_containing_this_readme>

<a name="start-minishift"></a>
### Start Minishift

We currently recommend you use at least 5Gb of RAM in your minishift VM and today we recommend at least 5 CPUs. Though longer term we'll add much lower CPU limits so that folks can omit that.

So start minishift using something like this:

    $ minishift start --memory=5GB --cpus=5 --disk-size=50GB

<a name="setup-github-oauth-client-id-and-secret"></a>
### Setup GitHub OAuth client ID and secret

Fabric8 has GitHub integration letting you browse repositories, create new repositories, edit projects and setup automated CI / CD jobs with webhooks on GitHub.

This requires an [OAuth application to be setup on your GitHub account](https://developer.github.com/apps/building-integrations/setting-up-and-registering-oauth-apps/registering-oauth-apps/) for Fabric8 and you need to obtain the client ID and secret for the OAuth application.

You will need to register the redirect URI in the OAuth application to point to the output of this command:

    $ echo http://keycloak-fabric8.$(minishift ip).nip.io/auth/realms/fabric8/broker/github/endpoint

So please follow the following steps using the above redirect URL and `http://fabric8.io` as a sample homepage URL:

![Register OAuth App](https://raw.githubusercontent.com/fabric8io/fabric8-platform/master/images/register-oauth.png)

Once you have created the OAuth application for Fabric8 in your GitHub settings and found your client ID and secret, set the following environment variables:

    $ export GITHUB_OAUTH_CLIENT_ID=TODO
    $ export GITHUB_OAUTH_CLIENT_SECRET=TODO

where the above `TODO` text is replaced by the actual client id and secret from your GitHub settings page!

<a name="apply-add-on"></a>
### Apply add-on

Once you have the 2 GitHub environment variables defined you can apply the Fabric8 addon via:

    $ minishift addon apply --addon-env GITHUB_OAUTH_CLIENT_ID=$GITHUB_OAUTH_CLIENT_ID --addon-env GITHUB_OAUTH_CLIENT_SECRET=$GITHUB_OAUTH_CLIENT_SECRET fabric8
