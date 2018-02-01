// Moved from conflicting integration_test.go
// will be added to the che package. (agajdosi)

		// steps for testing che addon
		cheAPI := util.CheAPI{
			CheAPIEndpoint: "",
		}
	
		cheAPIRunner := &CheRunner{
			runner: cheAPI,
		}
	
		s.Step(`^applying openshift token succeeds$`, minishift.applyingOpenshiftTokenSucceeds)
	
		// steps for testing che addon
		s.Step(`^we try to get the che api endpoint$`, cheAPIRunner.weTryToGetTheCheApiEndpoint)
		s.Step(`^che api endpoint should not be empty$`, cheAPIRunner.cheApiEndpointShouldNotBeEmpty)
		s.Step(`^we try to get the stacks information$`, cheAPIRunner.weTryToGetTheStacksInformation)
		s.Step(`^the stacks should not be empty$`, cheAPIRunner.theStacksShouldNotBeEmpty)
		s.Step(`^starting a workspace with stack "([^"]*)" succeeds$`, cheAPIRunner.startingAWorkspaceWithStackSucceeds)
		s.Step(`^workspace should have state "([^"]*)"$`, cheAPIRunner.workspaceShouldHaveState)
		s.Step(`^importing the sample project "([^"]*)" succeeds$`, cheAPIRunner.importingTheSampleProjectSucceeds)
		s.Step(`^workspace should have (\d+) project$`, cheAPIRunner.workspaceShouldHaveProject)
		s.Step(`^user runs command on sample "([^"]*)"$`, cheAPIRunner.userRunsCommandOnSample)
		s.Step(`^exit code should be (\d+)$`, cheAPIRunner.exitCodeShouldBe)
		s.Step(`^user stops workspace$`, cheAPIRunner.userStopsWorkspace)
		s.Step(`^workspace is removed$`, cheAPIRunner.workspaceIsRemoved)
		s.Step(`^workspace removal should be successful$`, cheAPIRunner.workspaceRemovalShouldBeSuccessful)
