# Fabric8 Launcher Add-on

This is an add-on to install Fabric8 Launcher

Verify you have installed these addons, by following the general [readme](https://github.com/minishift/minishift-addons/blob/master/README.adoc#download-and-use-community-add-ons).

As explained in the readme, clone the repository to get addons to your workstation.

## Start Minishift

Start minishift with additional memory allocation.

```
$ minishift start --memory=4GB
```

Depending on the number of boosters you plan on running, the memory allocated to minishift will vary and should be more than the 2GB default.


## Install Add-on

Run the following command after you start minishift.

```
$ minishift addon install <path_to_directory_containing_this_readme>
```

## Deploy Add-on

1. You'll need a github account. 
2. Navigate to [https://github.com/settings/tokens](https://github.com/settings/tokens)
3. Select Generate new token
4. Add a token description, for example Fabric8 Launcher tool on a Single-node OpenShift Cluster.
5. Select the check boxes of the following parent scopes and all their children:
	* public_repo
	* read:org
	* admin:repo_hook
6. Click `Generate Token`
7. Save the hex code of the personal access token.
8. To deploy launcher substituting the values for the variables.

```
$ minishift addons apply fabric8-launcher \
   --addon-env GITHUB_USERNAME=<yourgithubusername> \
   --addon-env GITHUB_TOKEN=<yourtoken>
```

This creates a project with name `rhoarpad` and spins up the launcher in that project. 

## Remove Add-on

To remove add-on simply run

```
$ minishift addons remove fabric8-launcher
```

## Uninstall Add-on
To uninstall add-on run

```
$ minishift addons uninstall fabric8-launcher
```


