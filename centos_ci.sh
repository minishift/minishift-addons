#!/bin/bash

# Output command before executing
set -x

# Exit on error
set -e

# Source environment variables of the jenkins slave
# that might interest this worker.
function load_jenkins_vars() {
  if [ -e "jenkins-env" ]; then
    cat jenkins-env \
      | grep -E "(JENKINS_URL|GIT_BRANCH|GIT_COMMIT|BUILD_NUMBER|ghprbSourceBranch|ghprbActualCommit|BUILD_URL|ghprbPullId|CICO_API_KEY|GITHUB_TOKEN|JOB_NAME|RH_REGISTRY_USERNAME|RH_REGISTRY_PASSWORD)=" \
      | sed 's/^/export /g' \
      > ~/.jenkins-env
    source ~/.jenkins-env
  fi

  echo 'CICO: Jenkins ENVs loaded'
}

function install_core_deps() {
  # Enable extra packages
  yum --enablerepo=extras install -y epel-release
  # Get all the deps in
  yum -y install gcc \
                 golang \
                 make \
                 tar \
                 zip \
                 git \
                 curl \
                 python-requests

  echo 'CICO: Core dependencies installed'
}

# Create a CI user which has NOPASSWD sudoer role
function prepare_ci_user() {
  groupadd -g 1001 -r minishift_ci && useradd -g minishift_ci -u 1001 minishift_ci
  chmod +w /etc/sudoers && echo "minishift_ci ALL=(ALL)    NOPASSWD: ALL" >> /etc/sudoers && chmod -w /etc/sudoers

  # Copy centos_ci.sh to newly created user home dir
  cp centos_ci.sh /home/minishift_ci/
  mkdir /home/minishift_ci/payload
  # Copy minishift-addon repo content into minishift_ci user payload directory for later use
  cp -R . /home/minishift_ci/payload
  chown -R minishift_ci:minishift_ci /home/minishift_ci/payload

  # Copy the jenkins-env into minishift_ci home dir
  cp ~/.jenkins-env /home/minishift_ci/jenkins-env
}

function install_kvm_virt() {
  sudo yum -y install kvm \
                      qemu-kvm \
                      libvirt
  # Start Libvirt
  sudo systemctl start libvirtd
  echo 'CICO: KVM hypervisor installed and started'

   # Add minishift_ci to libvirt group
  gpasswd -a minishift_ci libvirt && systemctl restart libvirtd
}

function setup_build_environment() {
  load_jenkins_vars;
  prepare_ci_user;
  install_core_deps;
  install_kvm_virt;
  runuser -l minishift_ci -c "/bin/bash centos_ci.sh"
}

#### Below functions are executed by minishift_ci user
function setup_kvm_docker_machine_driver() {
  curl -L https://github.com/dhiltgen/docker-machine-kvm/releases/download/v0.7.0/docker-machine-driver-kvm > docker-machine-driver-kvm && \
  chmod +x docker-machine-driver-kvm && sudo mv docker-machine-driver-kvm /usr/local/bin/docker-machine-driver-kvm
  echo 'CICO: Setup KVM docker-machine driver setup successfully'
}

function setup_golang() {
  # Show which version of golang in the offical repo.
  go version
  # Setup GOPATH
  mkdir $HOME/gopath $HOME/gopath/src $HOME/gopath/bin $HOME/gopath/pkg
  export GOPATH=$HOME/gopath
  export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
}

function setup_repo() {
  # Setup minishift repo
  mkdir -p $GOPATH/src/github.com/minishift
  cp -r /home/minishift_ci/payload $GOPATH/src/github.com/minishift/minishift-addons
}

function setup_godep() {
  GODEP_OS_ARCH=`go env GOHOSTOS`-`go env GOHOSTARCH`
  GODEP_TAG=v0.3.2
  GODEP_LATEST_RELEASE_URL="https://github.com/golang/dep/releases/download/${GODEP_TAG}/dep-${GODEP_OS_ARCH}"
  mkdir /tmp/godep
  curl -L ${GODEP_LATEST_RELEASE_URL} -o /tmp/godep/dep
  chmod +x /tmp/godep/dep
  export PATH=$PATH:/tmp/godep/
}

function prepare_repo() {
  setup_golang;
  setup_repo;
  setup_godep;
  echo "CICO: Preparation complete"
}

function perform_nightly() {
  MINISHIFT_ISO_URL=$1 MINISHIFT_VM_DRIVER=kvm make integration
}

# Join the array element by specified delimited character
function join_by() {
  local IFS="$1"; shift; echo "$*";
}

function perform_pr() {
  # Get name of addons which are changed in the PR
  updated_addons=$(git show --pretty="" --name-only HEAD | grep ".feature" | sed 's/.*\///' | sed 's/\.feature//')

  if [[ ${#updated_addons} -gt 0 ]]; then
    tags=$(join_by , ${updated_addons[@]})
    echo "Performing integration test with tags - $tags"
    MINISHIFT_ISO_URL=$1 MINISHIFT_VM_DRIVER=kvm make integration GODOG_OPTS="--tags $tags"
  else
    echo "No changes in test/integration/features files."
  fi
}

if [[ "$UID" = 0 ]]; then
  setup_build_environment;
else
  source ~/jenkins-env # Source environment variables for minishift_ci user
    # Export GITHUB_ACCESS_TOKEN
  export GITHUB_ACCESS_TOKEN=$GITHUB_TOKEN

  prepare_repo;
  setup_kvm_docker_machine_driver;
  # Navigate to the repo
  cd $GOPATH/src/github.com/minishift/minishift-addons

  if [[ "$JOB_NAME" = "minishift-addons-nightly-centos" ]]; then
    perform_nightly "centos"
  elif [[ "$JOB_NAME" = "minishift-addons-pr" ]]; then
    perform_pr "centos"
  fi
fi
