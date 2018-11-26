Note: https://github.com/fluent/fluentd-kubernetes-daemonset/issues/173

## But

Dans cette mise en pratique vous allez déploiement des agents **fluentd** sur l'ensemble des machines du cluster. Ces agents seront configurés pour envoyer les logs dans l'instance d'Elasticsearch déployée dans un exercice précédent.

## Pré-requis

Assurez-vous que la stack Elastic déployée précédemment est toujours active, vous devrez la relancer si ce n'est pas le cas.

## DaemonSet

Un daemonset assure qu'un Pod tourne sur l'ensemble des machines du cluster.

La spécification suivante définie un DaemonSet utilisé pour assurer qu'un Pod contenant un container **fluentd** est lancé sur chaque node du cluster.
Ce container est configuré pour envoyer les entrées de logs dans l'instance **elasticsearch** qui tourne sur le cluster.

```
apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
  name: fluentd
  namespace: kube-system
  labels:
    k8s-app: fluentd-logging
    version: v1
    kubernetes.io/cluster-service: "true"
spec:
  template:
    metadata:
      labels:
        k8s-app: fluentd-logging
        version: v1
        kubernetes.io/cluster-service: "true"
    spec:
      tolerations:
      - key: node-role.kubernetes.io/master
        effect: NoSchedule
      containers:
      - name: fluentd
        image: fluent/fluentd-kubernetes-daemonset:elasticsearch
        env:
          - name: FLUENT_UID
            value: "0"
          - name:  FLUENT_ELASTICSEARCH_HOST
            value: "elasticsearch.default.svc.cluster.local"
          - name:  FLUENT_ELASTICSEARCH_PORT
            value: "9200"
          - name: FLUENT_ELASTICSEARCH_SCHEME
            value: "http"
        volumeMounts:
        - name: varlog
          mountPath: /var/log
        - name: varlibdockercontainers
          mountPath: /var/lib/docker/containers
          readOnly: true
      terminationGracePeriodSeconds: 30
      volumes:
      - name: varlog
        hostPath:
          path: /var/log
      - name: varlibdockercontainers
        hostPath:
          path: /var/lib/docker/containers
```

## Test de la réception des logstash

Depuis l'interface de Grafana, vérifié que de nouvelles entrées de logs ont été reçues.
