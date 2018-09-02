@dynamic-admission-controllers

Feature: Feature for dynamic-admission-controllers

  @minishift-only
  Scenario: User installs dynamic-admission-controllers add-on
     When executing "minishift addons install ../../add-ons/dynamic-admission-controllers" succeeds
     Then stdout should contain "Addon 'dynamic-admission-controllers' installed"

  Scenario: User can apply the dynamic-admission-controllers add-on
    Given executing "minishift start" succeeds
     When executing "minishift addons apply dynamic-admission-controllers" succeeds
     Then stdout should contain "Dynamic admission controllers add-on successfully applied"

  Scenario: User can remove the dynamic-admission-controllers add-on
     When executing "minishift addons remove dynamic-admission-controllers" succeeds
     Then stdout should contain "Dynamic admission controllers add-on successfully removed"

  Scenario: User can uninstall dynamic-admission-controllers add-on
     When executing "minishift addons uninstall dynamic-admission-controllers" succeeds
     Then stdout should contain "Add-on 'dynamic-admission-controllers' uninstalled"
      And stdout of command "minishift addons list" does not contain "dynamic-admission-controllers"

  Scenario: Deleting Minishift
    When executing "minishift delete --force" succeeds
    Then Minishift should have state "Does Not Exist"
