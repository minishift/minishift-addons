# Deploying Debezium on OpenShift

This addon provides an easy way to install [Debezium](http://debezium.io/) on [Minishift](https://github.com/minishift/minishift).

Prerequisites:

 * [Installed and running](https://docs.okd.io/latest/minishift/getting-started/installing.html) Minishift
 * [Installed](https://docs.okd.io/latest/minishift/command-ref/minishift_oc-env.html) OpenShift CLI

## Start Minishift
The deployment works with Minishift default resources - 2 CPUs and 2 GB RAM. Nevertheless we prefer to allocate more memory (4 GB) available to Debezium and associated infrastructure. Start Minishift using following command to provide more RAM.
```
$ minishift start --memory=4GB
```

## Add-on installation
Clone this repository onto your local machine and then install the add-on via:
```
    $ minishift addons install <path_to_directory_containing_this_readme>
```

## Debezium start
Deploy the Kafka broker, Kafka Connect with Debezium and MySQL connector

```
minishift addon apply -a DEBEZIUM_VERSION=0.6.1 -a DEBEZIUM_PLUGIN=mysql -a PROJECT=myproject debezium
```

After a while all parts should be up and running:

```
oc get pods
NAME                    READY     STATUS      RESTARTS   AGE
debezium-1-build        0/1       Completed   0          3m
debezium-2-build        0/1       Completed   0          3m
kafka-0                 1/1       Running     2          3m
kafka-1                 1/1       Running     0          2m
kafka-2                 1/1       Running     0          2m
kafka-connect-3-3v4n9   1/1       Running     1          3m
zookeeper-0             1/1       Running     0          3m
```

**Note:** You might see one or two debezium builds in the above output depending on the timing of `oc get pods` command. In both the cases it is fine.

## Supported parameters
* `DEBEZIUM_VERSION` - the verson of Debezium to be used (only released versions are supported)
* `DEBEZIUM_PLUGIN` - which plugin should be added into the Connect cluster
* `PROJECT` - the name of the project to which Debezium is deployed

## Debezium Tutorial
You can try the [Debezium Tutorial](http://debezium.io/docs/tutorial/) in this environment too. Yoy can either follow the steps below to dpeloy the test database or use a [prepared MiniShift add-on](https://github.com/debezium/debezium-examples/tree/master/openshift/tutorial-database) for that purpose.

First we need to start a MySQL server instance:

```
# Deploy pre-populated MySQL instance
oc new-app --name=mysql debezium/example-mysql:0.6

# Configure credentials for the database
oc env dc/mysql  MYSQL_ROOT_PASSWORD=debezium  MYSQL_USER=mysqluser MYSQL_PASSWORD=mysqlpw
```

A new pod with MySQL server should be up and running:

```
oc get pods
NAME                             READY     STATUS      RESTARTS   AGE
...
mysql-1-4503l                    1/1       Running     0          2s
...
```

Then we are going to register the Debezium MySQL connector to run against the deployed MySQL instance:

```
cat register.json | oc exec -i kafka-0 -- curl -s -X POST -H "Accept:application/json" -H "Content-Type:application/json" http://kafka-connect:8083/connectors -d @-
```

 **Note:** You can find the register.json in the debezium add-on directory.

Kafka Connect's log file should contain messages regarding execution of initial snapshot:

```
oc logs $(oc get pods -o name -l name=kafka-connect)
```

Read customer table CDC messages from the Kafka topic:

```
oc exec -it kafka-0 -- /opt/kafka/bin/kafka-console-consumer.sh \
    --bootstrap-server kafka:9092 \
    --from-beginning \
    --property print.key=true \
    --topic dbserver1.inventory.customers
```

Modify some records in the `CUSTOMERS` table of the database:

```
oc exec -it $(oc get pods -o custom-columns=NAME:.metadata.name --no-headers -l app=mysql) -- bash -c 'mysql -u $MYSQL_USER -p$MYSQL_PASSWORD inventory'
```

You should see additional change messages in the consumer started before.
