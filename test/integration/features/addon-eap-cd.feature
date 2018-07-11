@eap-cd @addon-eap-cd @addon
Feature: eap-cd add-on
  Eap-cd add-on imports eap-cd imagestreams and templates, which are then available in OpenShift to the user.

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
     Then stdout should contain "EAP CD imagestreams and templates installed"

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
     Then stdout should contain "Product: JBoss EAP CD 7.2.0.CD13"

  Scenario: User deletes Minishift
    Given Minishift has state "Running"
     When executing "minishift delete --force" succeeds
     Then Minishift should have state "Does Not Exist"
