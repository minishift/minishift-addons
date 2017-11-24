#!/bin/sh

set -e
[[ -z "$1" ]] && { echo "Need to supply namespace that grafana is deployed to" ; exit 1; }

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

NAMESPACE=$1
DS_NAME=prometheus-ocp
DASH_FILE="./openshift-cluster-monitoring.json"
eval $(minishift oc-env)
oc login -u system:admin -n $NAMESPACE

pod_state=""
echo "wait until pod gets ready"
while [ "$pod_state" != "Running" ]
do
        pod_state=`oc get pod |grep grafana |awk '{print $3}'`
        sleep 1
done
sleep 10

echo "setup datasource and dashboard"
TOKEN=`oc sa get-token prometheus -n kube-system`
ROUTE=`oc get route |grep grafana |awk '{print $2}'`
PRO_SERVER=`oc get route --all-namespaces |grep prometheus |awk '{print $3}'`
JSON="{\"name\":\""$DS_NAME"\",\"type\":\"prometheus\",\"typeLogoUrl\":\"\",\"access\":\"proxy\",\"url\":\"https://"$PRO_SERVER"\",\"basicAuth\":false,\"withCredentials\":false,\"jsonData\":{\"tlsSkipVerify\":true,\"token\":\"$TOKEN\"}}"

# Add DS.
curl -H "Content-Type: application/json" -u admin:admin $ROUTE/api/datasources -X POST -d $JSON
echo

# Create new dashboard.
cat $DASH_FILE | \
  sed 's/${DS_PR}/'$DS_NAME'/' | \
  curl -H "Content-Type: application/json" -u admin:admin $ROUTE/api/dashboards/db -X POST -d @-

echo
echo "Access grafana via $(minishift openshift service grafana-ocp -n $NAMESPACE -u)"
echo "user / password: admin / admin"

exit 0
