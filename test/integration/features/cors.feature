@cors
Feature: Cors add-on
  As Minishift user I can install and apply Cors add-on from minishift-addons repository.

  Scenario: Installing the add-on
     When executing "minishift addons install ../../add-ons/cors" succeeds
     Then stdout should contain "Addon 'cors' installed"

  Scenario: Minishift starts
    Given Minishift has state "Does Not Exist"
     When executing "minishift start" succeeds
     Then Minishift should have state "Running"

  Scenario: Applying the add-on
     When executing "minishift addons apply cors" succeeds
     Then stdout should contain "CORS is now allowed from any address"

  Scenario: Deleting Minishift
    Given Minishift has state "Running"
     When executing "minishift delete --force" succeeds
     Then Minishift should have state "Does Not Exist"
