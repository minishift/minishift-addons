@kubevirt
Feature: KubeVirt add-on
    KubeVirt addon starts KubeVirt

    @minishift-only
    Scenario: User install kubevirt add-on
      Given stdout of command "minishift addons list" does not contain "kubevirt"
       When executing "minishift addons install ../../add-ons/kubevirt" succeeds
       Then stdout should contain "Addon 'kubevirt' installed"

    Scenario: Minishift starts
      Given Minishift has state "Does Not Exist"
       When executing "minishift start --memory 4GB" succeeds
       Then Minishift should have state "Running"

    Scenario: Applying the add-on
       When executing "minishift addons apply kubevirt" succeeds
       Then stdout should contain "Deployment applied, KubeVirt is starting up!"

    Scenario: KubeVirt is ready
      Given Minishift has state "Running"
       When executing "minishift openshift service list" succeeds
       Then stdout should contain "virt-api"

    Scenario: DaemonSet virt-handler is ready
      Given user waits "60" seconds
       When executing "oc get ds -n kube-system --as system:admin" succeeds
       Then stdout should match "virt-handler(\s+1){5}"

    Scenario: ReplicaSet virt-api and virt-controller are ready
      Given user waits "60" seconds
       When executing "oc get rs -n kube-system --as system:admin" succeeds
       Then stdout should match "virt-api-\w{10}(\s+2){3}"
        And stdout should match "virt-controller-\w{10}(\s+2){3}"

    Scenario: Deleting Minishift
      Given Minishift has state "Running"
       When executing "minishift delete --force" succeeds
       Then Minishift should have state "Does Not Exist"
