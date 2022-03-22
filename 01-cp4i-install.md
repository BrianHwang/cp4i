# create project
```
oc new-project cp4i-poc
oc projects
oc get projects
oc project cp4i-poc

```

# adding IBM catalogSource
https://www.ibm.com/docs/en/cloud-paks/cp-integration/2021.4?topic=installing-adding-catalog-sources-online-openshift-cluster


```
vi catalog-source.yaml
```
copy below
```
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: ibm-operator-catalog
  namespace: cp4i-poc
spec:
  displayName: IBM Operator Catalog
  image: 'icr.io/cpopen/ibm-operator-catalog:latest'
  publisher: IBM
  sourceType: grpc
  updateStrategy:
    registryPoll:
      interval: 45m
```
```
oc apply -f catalog-source.yaml
```

# operator-group
- installation mode is a specific namespace on the cluster
- https://www.ibm.com/docs/en/cloud-paks/cp-integration/2021.4?topic=installing-operators-using-cli

```
vi operator-group.yaml
```
copy below
```
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: ibm-integration-operatorgroup
  namespace: cp4i-poc
spec:
  targetNamespaces:
  - cp4i-poc
```
```
oc apply -f operator-group.yaml -n cp4i-poc
```

# IBM entitlement key
https://www.ibm.com/docs/en/cloud-paks/cp-integration/2021.4?topic=installing-applying-your-entitlement-key-online-installation

```
docker login cp.icr.io -u cp -p <entitlement_key>
```
```
# it will print as below

onfigure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```

```
oc create secret docker-registry ibm-entitlement-key \
    --docker-username=cp \
    --docker-password=<entitlement_key> \
    --docker-server=cp.icr.io \
    --namespace=cp4i-poc
```

```
# it will print as below
secret/ibm-entitlement-key created
```

# ibm-cp-integration operator

```
vi subscription.yaml
```

```
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibm-cp-integration
  namespace: cp4i-poc
spec:
  channel: v1.5
  name: ibm-cp-integration
  source: ibm-operator-catalog
  sourceNamespace: openshift-marketplace
```
failed once. create catalogSource from UI same as with namespace=openshift-marketplace 
https://www.ibm.com/docs/en/cloud-paks/cp-integration/2021.4?topic=installing-adding-catalog-sources-online-openshift-cluster
then re-run it goes well

NOTE : after this , how it check the status ?

```
oc apply -f subscription.yaml -n cp4i-poc
```


# Validating installation of an operator
- https://access.redhat.com/documentation/en-us/openshift_container_platform/4.2/html-single/operators/index
- csv : cluster service versoin 

```
oc get csv -n cp4i-poc
```

NOTE : why ibm nodes pods running
```
[cloudshell-user@ip-10-0-186-50 ~]$ oc get pods -o wide
NAME                                                             READY   STATUS             RESTARTS       AGE     IP            NODE                                             NOMINATED NODE   READINESS GATES
couchdb-operator-765c5968f6-f8c4g                                1/1     Running            0              3m55s   10.131.0.28   ip-10-41-84-29.ap-southeast-2.compute.internal   <none>           <none>
datapower-operator-54f8b74685-7h275                              1/1     Running            0              4m11s   10.128.2.36   ip-10-41-84-57.ap-southeast-2.compute.internal   <none>           <none>
datapower-operator-conversion-webhook-5479f58fd4-kcddz           1/1     Running            0              3m41s   10.131.0.30   ip-10-41-84-29.ap-southeast-2.compute.internal   <none>           <none>
eventstreams-cluster-operator-5cd4dcb699-2jlgx                   1/1     Running            0              3m43s   10.129.2.47   ip-10-41-84-43.ap-southeast-2.compute.internal   <none>           <none>
iaf-core-operator-controller-manager-77d9bb7bd-2vfst             0/1     Running            0              4m8s    10.131.0.26   ip-10-41-84-29.ap-southeast-2.compute.internal   <none>           <none>
ibm-ai-wmltraining-operator-6b487575f-gks7n                      1/1     Running            0              3m49s   10.131.0.29   ip-10-41-84-29.ap-southeast-2.compute.internal   <none>           <none>
ibm-apiconnect-7c57bdc98c-klpq8                                  0/1     CrashLoopBackOff   2 (26s ago)    3m39s   10.129.2.48   ip-10-41-84-43.ap-southeast-2.compute.internal   <none>           <none>
ibm-appconnect-operator-85ddfc759c-gv8vd                         1/1     Running            1 (72s ago)    3m57s   10.129.2.44   ip-10-41-84-43.ap-southeast-2.compute.internal   <none>           <none>
ibm-aspera-hsts-operator-6985495d64-x4c2f                        1/1     Running            0              3m59s   10.131.0.27   ip-10-41-84-29.ap-southeast-2.compute.internal   <none>           <none>
ibm-cloud-databases-redis-operator-5ccf8cc948-bg477              1/1     Running            0              4m18s   10.128.2.34   ip-10-41-84-57.ap-southeast-2.compute.internal   <none>           <none>
ibm-common-service-operator-6cdb8ff7d-ldxj7                      1/1     Running            0              4m15s   10.128.2.35   ip-10-41-84-57.ap-southeast-2.compute.internal   <none>           <none>
ibm-cp-integration-74cb979f6f-r5z8p                              1/1     Running            0              3m47s   10.129.2.46   ip-10-41-84-43.ap-southeast-2.compute.internal   <none>           <none>
ibm-integration-asset-repository-operator-86749f95cc-tthnc       1/1     Running            3 (2m9s ago)   3m59s   10.129.2.43   ip-10-41-84-43.ap-southeast-2.compute.internal   <none>           <none>
ibm-integration-operations-dashboard-operator-5669bcdc67-6mf8v   1/1     Running            2 (108s ago)   3m54s   10.129.2.45   ip-10-41-84-43.ap-southeast-2.compute.internal   <none>           <none>
ibm-integration-platform-navigator-operator-8f76bdf8c-bn4vs      1/1     Running            0              4m6s    10.129.2.42   ip-10-41-84-43.ap-southeast-2.compute.internal   <none>           <none>
ibm-mq-86dcc854bb-8nwrp                                          1/1     Running            4 (114s ago)   4m10s   10.128.2.37   ip-10-41-84-57.ap-southeast-2.compute.internal   <none>           <none>
ibm-operator-catalog-jmxds                                       1/1     Running            0              14m     10.128.2.11   ip-10-41-84-57.ap-southeast-2.compute.internal   <none>           <none>
```



# deploy IBM cloud pak for integration
https://www.ibm.com/docs/en/cloud-paks/cp-integration/2021.4?topic=installing-deploying-cloud-pak-integration-using-cli

TODO : play around from UI, get yaml format, set below 

```
vi platformnavigator.yaml
```

```
apiVersion: integration.ibm.com/v1beta1
kind: PlatformNavigator
metadata:
    name: integration-quickstart
    namespace: cp4i-poc
spec:
    license:
        accept: true
        license: L-RJON-C7QG3S
    requestIbmServices:
        licensing: true
    mqDashboard: true
    replicas: 1
    storage:
        class: "storage_class"
    version: 2021.4.1
``` 


```
oc apply -f platformnavigator.yaml
```

```
oc describe PlatformNavigator integration-quickstart --namespace=cp4i-poc
```
# install ACE
TODO : node selection
