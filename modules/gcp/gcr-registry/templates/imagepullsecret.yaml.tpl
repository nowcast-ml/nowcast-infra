apiVersion: v1
kind: Secret
metadata:
  name: ${name}
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: ${dockerconfigjson}
