@che
Feature: Che add-on
  Che addon starts Eclipse Che

  @minishift-only
  Scenario: User installs che add-on
    When executing "minishift addons install ../../add-ons/che" succeeds
    Then stdout should contain "Addon 'che' installed"

  Scenario: Che add-on is installed
    When executing "minishift addons list" succeeds
    Then stdout should contain "che"
  
  Scenario: User starts Minishift
    Given Minishift has state "Does Not Exist"
    When executing "minishift start --memory=5GB" succeeds
    Then Minishift should have state "Running"

  Scenario: User applies Che add-on
    When applying che addon succeeds
    Then stdout should contain "Please wait while the pods all startup!"

  Scenario: Che is ready
    Given Minishift has state "Running"
    When executing "oc project mini-che" succeeds
    Then service "che" rollout successfully within "300" seconds

  Scenario: Che API is accessible
    When user tries to get the che api endpoint
    Then che api endpoint should not be empty

  Scenario: Che stacks are accessible
    When user tries to get the stacks information
    Then the stacks should not be empty

  Scenario Outline: User starts workspace, imports projects, checks run commands
    When starting a workspace with stack "<stack>" succeeds
    Then workspace should have state "RUNNING"

    When importing the sample project "<sample>" succeeds
    Then workspace should have 1 project

    When user runs command on sample "<sample>"
    Then exit code should be 0

    When stopping a workspace succeeds
    Then workspace should have state "STOPPED"

    When workspace is removed
    Then workspace removal should be successful

    Examples:
    | stack                 | sample                                                                   |
    | Eclipse Vert.x        | https://github.com/openshiftio-vertx-boosters/vertx-http-booster         |
    | Java CentOS           | https://github.com/che-samples/console-java-simple.git                   |
    | Spring Boot           | https://github.com/snowdrop/spring-boot-http-booster                     |
    | CentOS WildFly Swarm  | https://github.com/wildfly-swarm-openshiftio-boosters/wfswarm-rest-http  |
    | Python                | https://github.com/che-samples/console-python3-simple.git                |
    | PHP                   | https://github.com/che-samples/web-php-simple.git                        |
    | C++                   | https://github.com/che-samples/console-cpp-simple.git                    |

  Scenario: User deletes Minishift
     When executing "minishift delete --force" succeeds
     Then Minishift should have state "Does Not Exist"
