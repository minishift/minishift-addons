# Eclipse Che Addon

This addon create Eclipse Che templates, image streams and a project running Che in Minishift. In short this helps in setting up Eclipse Che 
on Minishift inline with [Deploy Che on Minishift](https://www.eclipse.org/che/docs/setup/openshift/index.html#deploy-che-on-minishift)

<!-- MarkdownTOC -->

- [Using the Eclipse Che Add-on](#using-the-eclipse-che-add-on)
	- [Install add-on](#install-add-on)
	- [Start Minishift](#start-minishift)
	- [Apply add-on](#apply-add-on)
	- [Replace Che stacks](#replace-stacks)
	- [Remove add-on](#remove-add-on)
	- [Uninstall add-on](#uninstall-add-on)

<!-- /MarkdownTOC -->

This addon provides an easy way to install Eclipse Che on MiniShift.

Eclipse Che provides a complete cloud IDE.

<a name="using-the-eclipse-che-add-on"></a>
## Using the Eclipse Che Add-on

The best way of using this add-on is via the [`minishift add-ons apply`](https://docs.openshift.org/latest/minishift/command-ref/minishift_addons_apply.html) command which is outlined in the following paragraphs.

<a name="install-add-on"></a>
### Install add-on
Che default stacks require root privilege to run sshd. Without root privilege, workspaces will take more time to timeout and start.
One workaround would be to enable the `anyuid` addon. Another way would be to [replace the existing stacks](#replace-stacks) with the ones without the `sshd` agent.

    $ minishift addons install --defaults
    $ minishift addons enable anyuid

Clone this repository onto your local machine and then install the add-on via:

    $ minishift addons install <path_to_directory_containing_this_readme>
    $ minishift addons enable che


`enable` will setup Eclipse Che when you start Minishift the next time.

<a name="start-minishift"></a>
### Start Minishift

Start Minishift using something like this:

    $ minishift start

However, as default memory is set to 2GB and a che-server takes about 700MB memory and a default stack workspace can reach 2GB,
we recommand to start Minishift with at least 5GB:

    $ minishift start --memory=5GB 

<a name="apply-add-on"></a>
### Apply add-on
If Minishift is already started and che addon is installed. It is possible to deploy che without restarting Minishift:


    $ minishift addons apply che


<a name="replace-stacks"></a>
### Replace Che stacks
Once Che is up and running,

    $ STACKS_SCRIPT_URL=https://raw.githubusercontent.com/eclipse/che/master/dockerfiles/init/modules/openshift/files/scripts/replace_stacks.sh
    $ curl -fsSL ${STACKS_SCRIPT_URL} -o ./stacks-che.sh
    $ oc project mini-che && bash ./stacks-che.sh


<a name="remove-add-on"></a>
### Remove add-on
To remove all created template and che project:


    $ minishift addons remove che

<a name="uninstall-add-on"></a>
### Uninstall add-on
To uninstall the addon from the addon list:


    $ minishift addons uninstall che

