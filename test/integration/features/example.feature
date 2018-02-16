@example
# tag @example is used to make this test executable by running `make integration ADDON=example`
# You can use this feature as an example of basic add-on test.

Feature: Example feature for example.addon

  Scenario: User can install example add-on
    Given stdout of command "minishift addons list" does not contain "example"
     When executing "minishift addons install ../../add-ons/example" succeeds
     Then stdout of command "minishift addons list" contains "example"

  Scenario: User can apply the example add-on
    Given executing "minishift start" succeeds
     When executing "minishift addons apply example" succeeds
     Then stdout should contain "Example add-on successfully applied"

  Scenario: User can remove the example add-on
     When executing "minishift addons remove example" succeeds
     Then stdout should contain "Example add-on successfully removed"

  Scenario: User can uninstall example add-on
     When executing "minishift addons uninstall example" succeeds
     Then stdout should contain "Add-on 'example' uninstalled"
      And stdout of command "minishift addons list" does not contain "example"

  Scenario: Deleting Minishift
    When executing "minishift delete --force" succeeds
    Then Minishift should have state "Does Not Exist"
