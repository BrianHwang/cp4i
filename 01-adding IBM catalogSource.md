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
installation mode is a specific namespace on the cluster
https://www.ibm.com/docs/en/cloud-paks/cp-integration/2021.4?topic=installing-operators-using-cli

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

# ibm-cp-integration operator
vi subscription.yaml
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

```
oc apply -f subscription.yaml -n cp4i-poc
```


# Validating installation of an operator

```
oc get csv -n cp4i-poc
```



docker login cp.icr.io -u cp -p <entitlement_key>

--- print as below ---- 
onfigure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
-----

```
oc create secret docker-registry ibm-entitlement-key \
    --docker-username=cp \
    --docker-password=<entitlement_key> \
    --docker-server=cp.icr.io \
    --namespace=cp4i-poc
```


secret/ibm-entitlement-key created

