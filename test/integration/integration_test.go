// +build integration

package integration

import (
	"os"
	"strings"
	"testing"

	"github.com/DATA-DOG/godog"
	"github.com/minishift/minishift/test/integration/testsuite"
)

func TestMain(m *testing.M) {
	parseFlags()
	testsuite.HandleISOVersion()

	status := godog.RunWithOptions("minishift", func(s *godog.Suite) {
		getFeatureContext(s)
	}, godog.Options{
		Format:              testsuite.GodogFormat,
		Paths:               strings.Split(testsuite.GodogPaths, ","),
		Tags:                testsuite.GodogTags,
		ShowStepDefinitions: testsuite.GodogShowStepDefinitions,
		StopOnFailure:       testsuite.GodogStopOnFailure,
		NoColors:            testsuite.GodogNoColors,
	})

	if st := m.Run(); st > status {
		status = st
	}
	os.Exit(status)
}

func getFeatureContext(s *godog.Suite) {
	// loads step definitions from the Minishift integration testsuite
	testsuite.FeatureContext(s)

	// loads additional step definitions for minishift-addons
	// mypackage.FeatureContext(s)
}

func parseFlags() {
	// gets flag values used by Minishift intefration testsuite
	testsuite.ParseFlags()
	// here you can get additional flag values if needed, for example:
	// mypackage.ParseFlags()
}
