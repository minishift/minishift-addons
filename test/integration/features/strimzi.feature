@strimzi
Feature: Feature for strimzi

  @minishift-only
  Scenario: User installs strimzi add-on
     When executing "minishift addons install ../../add-ons/strimzi" succeeds
     Then stdout should contain "Addon 'strimzi' installed"

  Scenario: User can uninstall strimzi add-on
     When executing "minishift addons uninstall strimzi" succeeds
     Then stdout should contain "Add-on 'strimzi' uninstalled"
      And stdout of command "minishift addons list" does not contain "strimzi"

  Scenario: Deleting Minishift
    When executing "minishift delete --force" succeeds
    Then Minishift should have state "Does Not Exist"
