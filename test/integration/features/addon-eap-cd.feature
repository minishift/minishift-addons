@eap-cd @addon-eap-cd @addon
Feature: eap-cd add-on
  Eap-cd add-on imports eap-cd imagestreams and templates, which are then available in OpenShift to the user.
  NOTE: This feature requires valid username and password into "registry.redhat.io" to be set as RH_REGISTRY_USERNAME
  and RH_REGISTRY_PASSWORD environment variables in order to run successfully.

  @minishift-only
  Scenario: User enables redhat-registry-login addon
     When executing "minishift addons enable redhat-registry-login" succeeds
     Then exitcode should equal "0"

  @minishift-only
  Scenario: User sets registry username and password
     When executing "minishift config set addon-env REGISTRY_USERNAME=env.RH_REGISTRY_USERNAME,REGISTRY_PASSWORD=env.RH_REGISTRY_PASSWORD" succeeds
     Then executing "minishift config view" succeeds
      And stdout should match
      """
      - addon-env\s+: \[REGISTRY_USERNAME=env\.RH_REGISTRY_USERNAME REGISTRY_PASSWORD=env\.RH_REGISTRY_PASSWORD\]
      """

  @minishift-only
  Scenario: Installing the add-on
     When executing "minishift addons install ../../add-ons/eap-cd" succeeds
     Then stdout should contain "Addon 'eap-cd' installed"

  Scenario: Minishift starts
    Given Minishift has state "Does Not Exist"
     When executing "minishift start" succeeds
     Then Minishift should have state "Running"

  Scenario: Applying the add-on
     When executing "minishift addons apply eap-cd" succeeds
     Then stdout should contain "EAP CD 15 imagestreams and templates installed"

  Scenario: Deployment of eap-cd-basic application
    Given Minishift has state "Running"
     When executing "oc new-app eap-cd-basic-s2i" retrying 10 times with wait period of 2 seconds
      And executing "oc set probe dc/eap-app --readiness --get-url=http://:8080/index.jsf" succeeds
      And service "eap-app" rollout successfully within "1200" seconds
     Then with up to "10" retries with wait period of "500ms" the "body" of HTTP request to "/index.jsf" of service "eap-app" in namespace "myproject" contains "Welcome to JBoss!"
      And with up to "10" retries with wait period of "500ms" the "status code" of HTTP request to "/index.jsf" of service "eap-app" in namespace "myproject" is equal to "200"

  Scenario: Application pod is using correct version of EAP-CD
    Given setting scenario variable "POD_NAME" to the stdout from executing "oc get pod --selector app=eap-cd-basic-s2i -o name"
     When executing "oc rsh $(POD_NAME) /opt/eap/bin/jboss-cli.sh -c version" succeeds
     Then stdout should contain "Product: JBoss EAP CD 7.3.0.CD15"

  Scenario: User deletes Minishift
    Given Minishift has state "Running"
     When executing "minishift delete --force" succeeds
     Then Minishift should have state "Does Not Exist"
