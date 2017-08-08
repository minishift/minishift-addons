# Fabric8 Addon

This addon provides an easy way to install fabric8 on MiniShift. 

Fabric8 provides a complete developer platform for creating projects, editing them and performing full CI / CD for the entire developer lifecycle.

## Setup GitHub OAuth client ID and secret

Fabric8 has GitHub integration letting you browse repositories, create new repositories, edit projects and setup automated CI / CD jobs with webhooks on github. 

This requires an [OAuth application to be setup on your github account](https://developer.github.com/apps/building-integrations/setting-up-and-registering-oauth-apps/registering-oauth-apps/) for fabric8 and you need to obtain the client ID and secret for the OAuth application.


You will need to register the redirect URI in the OAuth application to point to the output of this command:

```
echo http://keycloak-fabric8.$(minishift ip).nip.io/auth/realms/fabric8/broker/github/endpoint
```

So please follow the following steps using the above redirect URL and `http://fabric8.io` as a sample homepage URL:


![Register OAuth App](https://raw.githubusercontent.com/fabric8io/fabric8-platform/master/images/register-oauth.png)


Once you have created the OAuth application for fabric8 in your github settings and found your client ID and secret then type the following:

```
export GITHUB_OAUTH_CLIENT_ID=TODO
export GITHUB_OAUTH_CLIENT_SECRET=TODO
```

where the above `TODO` text is replaced by the actual client id and secret from your github settings page!

## Applying the Addon

We currently recommend you use at least 5Gb of RAM in your minishift VM and today we recommend at least 5 CPUs. Though longer term we'll add much lower CPU limits so that folks can omit that.

So start minishift using something like this:

```
minishift start --memory=5000 --cpus=5 --disk-size=50g
```

Once you have the 2 GitHub environment variables defined above you can apply the fabric8 addon via:

```
minishift addon apply --addon-env GITHUB_OAUTH_CLIENT_ID=$GITHUB_OAUTH_CLIENT_ID --addon-env GITHUB_OAUTH_CLIENT_SECRET=$GITHUB_OAUTH_CLIENT_SECRET fabric8

```
