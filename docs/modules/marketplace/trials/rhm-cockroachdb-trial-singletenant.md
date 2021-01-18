# Trying CockroachDB

## Prerequistites

Create a project in your OpenShift cluster where you want the operator to be installed. Prefix the project name with your workshop username.

```text
oc new-project ##username##-cockroachdb
```

## Try software

Let's see how the `Free Trial` option works by selecting an SQL Operator. Go to the Marketplace catalog and search for `CockroachDB`. Select the `CockraochDB` tile. The `CockraochDB` product page gives you an overview, documentation, and pricing options associated with the product selected. Click on `Free Trail` button.

![CockroachDB free trial](images/rhm-cockroachdb-free-trial.png)

Next, the purchase summary will show the `Subscription term` and total cost is $0.00. Click `Start trial`. Go back to `Workspace > My Software` to view the list of purchased software.

## Operator install

Select the `CockraochDB` tile and then select the `Operators` tab. Click on `Install Operator` button. Leave the default selection for `Update channel` and `Approval strategy`. Select the cluster and namespace scope as `cockroachdb-test` for the operator and click `Install`.

![Operator install](images/rhm-cockroachdb-operator-install-dialog.png)

A message as shown below appears at the top of your screen indicating the install process initiated in the cluster.

![Request initiate](images/rhm-operator-install-request-initiate.png)

Log into your OpenShift cluster and look under `Operators > Installed Operators` to confirm the install was successful. The operator should list under the project `cockroachdb-test`.

![Successful install](images/rhm-cockroachdb-install-success.png)

## Create Database

From the installed Operators page for CockroachDB, click on the link `CockroachDB` under Provided APIs.

![Create instance](images/rhm-cockroachdb-instance-install.png)

Click on `Create Cockroachdb` button. Accept the default YAML and click on `Create` button. \[Follow the instructions [here](https://www.cockroachlabs.com/docs/stable/orchestrate-a-local-cluster-with-kubernetes.html) to set up the database in a secure mode.\]

![Install YAML](images/rhm-cockroachdb-install-yaml.png)

CockroachDB pods should come up when the database install completes. Run the following commands to check the status.

```text
$ oc project cockroachdb-test
Now using project "cockroachdb-test" on server "https://c100-e.us-east.containers.cloud.ibm.com:32345".
```

```text
$ kubectl get pods
NAME                             READY   STATUS      RESTARTS   AGE
cockroachdb-7486949c78-kdvcm     1/1     Running     0          46m
example-cockroachdb-0            1/1     Running     0          36m
example-cockroachdb-1            1/1     Running     0          36m
example-cockroachdb-2            1/1     Running     0          36m
example-cockroachdb-init-l5m56   0/1     Completed   0          36m
```

Now, let's create a user and a database. We will use the following to command to spin up a CockroachDB client.

```text
kubectl run -it --rm cockroach-client \
--image=cockroachdb/cockroach \
--restart=Never \
--command -- \
./cockroach sql --insecure --host=example-cockroachdb-public.cockroachdb-test
```

```text
$ kubectl run -it --rm cockroach-client \
--image=cockroachdb/cockroach \
--restart=Never \
--command -- \
./cockroach sql --insecure --host=example-cockroachdb-public.cockroachdb-test

If you don't see a command prompt, try pressing enter.
root@example-cockroachdb-public.cockroachdb-test:26257/defaultdb>
```

From the client command prompt, run the following SQL commands:

Create user `maxroach`

```text
CREATE USER IF NOT EXISTS maxroach;
```

```text
root@example-cockroachdb-public.cockroachdb-test:26257/defaultdb> CREATE USER IF NOT EXISTS maxroach;
CREATE USER 1

Time: 13.604101ms
```

Create the database `bank`

```text
 CREATE DATABASE bank;
```

```text
root@example-cockroachdb-public.cockroachdb-test:26257/defaultdb> CREATE DATABASE bank;
CREATE DATABASE

Time: 15.0454ms
```

Grant user the permission to update the database.

```text
GRANT ALL ON DATABASE bank TO maxroach;
```

```text
root@example-cockroachdb-public.cockroachdb-test:26257/defaultdb> GRANT ALL ON DATABASE bank TO maxroach;
GRANT

Time: 14.835156ms
```

Type `\q` to quit the client console.

```text
root@example-cockroachdb-public.cockroachdb-test:26257/defaultdb> \q
pod "cockroach-client" deleted
```

## Access Database

Now, let's view the results of the commands we ran in the earlier steps via the admin console. Console can be accessed at localhost wwith port forwarding.

```text
kubectl port-forward example-cockroachdb-0 8080
```

```text
$ kubectl port-forward example-cockroachdb-0 8080
Forwarding from [::1]:8080 -> 8080
```

The page should load the `cluster overview`

![Cluster overview](images/rhm-cockroachdb-cluster-overview.png)

Click on `DATABASES` from the left navigation panel.

jdbc:postgresql://127.0.0.1:26257/bank?sslmode=disable example-cockroachdb-public.cockroachdb-test.svc.cluster.local

![Database tables](images/rhm-cockroachdb-cluster-database.png)

## Conclusion

The CockroachDB instance is now ready for use.
