@example
# tag @example is used to make this test executable by running `make integration ADDON=example`
# You can use this feature as an example of basic add-on test.

Feature: Example feature for example.addon
  Feature tests basic usage of `example.addon`. It installs, applies, removes
  and uninstalls the add-on to make sure it is compatible with used Minishift binary.

  Scenario: User can install example add-on
    Add-on installation does not require Minishift to be running. Add-on must
    match add-on requirements from Minishift side to pass this scenario.
    Given stdout of command "minishift addons list" does not contain "example"
     When executing "minishift addons install ../../add-ons/example" succeeds
     Then stdout of command "minishift addons list" contains "example"

  Scenario: User can apply the example add-on
    Minishift is started and the add-on is applied on running instance of Minishift.
    Given executing "minishift start" succeeds
     When executing "minishift addons apply example" succeeds
     Then stdout should contain "Example add-on successfully applied"

  Scenario: User can remove the example add-on
    Add-on is removed from running instance of Minishift, example.addon.remove
    must be implemented to pass this test.
     When executing "minishift addons remove example" succeeds
     Then stdout should contain "Example add-on successfully removed"

  Scenario: User can uninstall example add-on
    Add-on can be uninstalled properly. 
     When executing "minishift addons uninstall example" succeeds
     Then stdout should contain "Add-on 'example' uninstalled"
      And stdout of command "minishift addons list" does not contain "example"

  Scenario: Deleting Minishift
    Minishift can be successfully deleted after the usage of example.addon.
    When executing "minishift delete --force" succeeds
    Then Minishift should have state "Does Not Exist"
