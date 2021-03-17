# node-exporter-textfile-metrics-generator
This docker image can be used as an initContainer in a node exporter daemonset.
It will generate a .prom textfile metric files that can be read via '--collector.textfile.directory=/etc/textfile-metrics'.
I use it to specify static metrics for defining thresholds.  
Since these thresholds need to be different depending on what node the pod is started i needed a method to generate the roles files depending on the nodetype the pod is running on.
This initContainer requires a serviceAccount, ClusterRole and ClusterRoleBinding to access the kubernetes API.  It will query the labels of the node thus giving me the option to dertermine the node type and subsequentally the thresholds to use in alerting.

## Variables
```
METRIC_SOURCE_DIRECTORY=${METRIC_SOURCE_DIRECTORY:-/metrics-source}
METRIC_TARGET_DIRECTORY=${METRIC_TARGET_DIRECTORY:-/metrics-target}

NODE_NAME=${NODE_NAME:-}

NODE_LABEL=${NODE_LABEL:-}

APISERVER=https://kubernetes.default.svc
SERVICEACCOUNT=${SERVICEACCOUNT:-/var/run/secrets/kubernetes.io/serviceaccount}
```

## Kubernetes Manifest

### ServiceAccount
```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: node-exporter-textfile-metrics-generator
  namespace: default
```

### ClusterRole
```
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: node-exporter-textfile-metrics-generator
rules:
- apiGroups: [""]
  resources:
  - nodes
  verbs: ["get"]
```

### ClusterRoleBinding
```
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: node-exporter-textfile-metrics-generator      
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: node-exporter-textfile-metrics-generator
subjects:
- kind: ServiceAccount
  name: node-exporter-textfile-metrics-generator
  namespace: default
```
