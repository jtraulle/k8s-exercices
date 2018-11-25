# La stack ELK (Elastic)

Cette stack est très souvent utilisée notamment pour ingérer et indexer des logs. Elle est composée de 3 logiciels:
* Logstash qui permet de filtrer / formatter les données entrantes et de les envoyer à Elasticsearch (et à d'autres applications)
* Elasticsearch, le moteur responsable de l'indexation des données
* Kibana, l'application web permettant la visualisation des données

## Le but de cet exercice

Lancer une stack ELK en configurant Logstash de façon à :
- ce qu'il puisse recevoir des entrées de log sur un endpoint HTTP
- extraire le champs présent dans chaque entrée et ajouter des informations de reverse geocoding
- envoyer chaque ligne dans Elasticsearch

L'interface de Kibana nous permettra de visualiser les logs et de créer des dashboards.

Note: nous considérerons que les fichiers de log sont générés par un serveur web comme apache / nginx, cela nous sera utile pour spécifier la façon dont Logstash doit réaliser le parsing.

Dans cet exercice nous allons déployer la stack elastic (Logstash, Elasticsearch, Kibana) sur le cluster Kubernetes

## Création des fichiers manifests

Créez un nouveau répertoire, nommé **elastic**, et un répertoire **manifests** dans celui-ci. Dans cet exercice, nous utiliserons un shell depuis le répertoire **manifests**

### Elasticsearch

#### Spécification du Deployment

Copiez la spécification suivante dans le fichier **manifests/deploy-elasticsearch.yaml**.
Cette spécification sera utilisée pour créer un **Deployment** qui lancera l'application **elasticsearch** dans un Pod.

```
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: elasticsearch
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: elasticsearch
    spec:
      containers:
      - image: elasticsearch:5.5.2
        name: elasticsearch
        env:
        - name: ES_JAVA_OPTS
          value: -Xms512m -Xmx512m
```

#### Specification du Service

Copiez la spécification suivante dans le fichier **manifests/service-elasticsearch.yaml**.
Cette spécification sera utilisée pour exposer le Pod **elasticsearch** aux autres services du cluster.

```
apiVersion: v1
kind: Service
metadata:
  name: elasticsearch
spec:
  type: ClusterIP
  ports:
  - name: elasticsearch
    port: 9200
    targetPort: 9200
  selector:
    app: elasticsearch
```

### Kibana

#### Spécification du Deployment

Copiez la spécificatin suivante dans le fichier **manifests/deploy-kibana.yaml**.
Cette spécification sera utilisée pour créer un **Deployment** qui lancera l'application **kibana** dans un Pod.

```
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: kibana
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: kibana
    spec:
      containers:
      - image: kibana:5.5.2
        name: kibana
```


#### Spécification du Service

Copiez la spécification suivante le fichier **manifests/service-kibana.yaml**.
Cette spécification sera utilisée pour exposer le Pod **kibana** à l'extérieur du cluster.

```
apiVersion: v1
kind: Service
metadata:
  name: kibana
spec:
  type: NodePort
  ports:
  - port: 5601
    targetPort: 5601
    nodePort: 31501
  selector:
    app: kibana
```

### Logstash

#### Fichier de configuration

Nous allons configurer logstash pour qu'il écoute sur HTTP, qu'il parse les entrées de logs au format apache et qu'il envoie les structures json résultantes dans elasticsearch. Nous allons pour cela créer le fichier **logstash.conf** dans le répertoire **elastic**. Ce fichier contient la configuration suivante:

```
input {
 http {}
}

filter {
 grok {
   match => [ "message" , "%{COMBINEDAPACHELOG}+%{GREEDYDATA:extra_fields}"]
   overwrite => [ "message" ]
 }
 mutate {
   convert => ["response", "integer"]
   convert => ["bytes", "integer"]
   convert => ["responsetime", "float"]
 }
 geoip {
   source => "clientip"
   target => "geoip"
   add_tag => [ "nginx-geoip" ]
 }
 date {
   match => [ "timestamp" , "dd/MMM/YYYY:HH:mm:ss Z" ]
   remove_field => [ "timestamp" ]
 }
 useragent {
   source => "agent"
 }
}

output {
 elasticsearch {
   hosts => ["elasticsearch:9200"]
 }
 stdout { codec => rubydebug }
}
```

Ce fichier peu sembler un peu compliqué. Il peut être découpé en 3 parties:
* input: permet de spécifier les données d'entrée. Nous spécifions ici que logstash peut recevoir des données (entrées de logs)  sur du http

* filter: permet de spécifier comment les données d'entrée doivent être traitées avant de passer à l'étape suivante. Plusieurs instructions sont utilisées ici:
  * grok permet de spécifier comment chaque entrée doit être parsée. De nombreux parseurs sont disponibles par défaut et nous spécifions ici (avec COMBINEDAPACHELOG) que chaque ligne doit être parsée suivant un format de log apache, cela permettra une extraction automatique des champs comme l'heure de création, l'url de la requête, l'ip d'origine, le code retour, ...
  * mutate permet de convertir les types de certains champs
  * geoip permet d'obtenir des informations géographique à partir de l'adresse IP d'origine
  * date est utilisée ici pour reformatter le timestamp

* output: permet de spécifier la destination d'envoi des données une fois que celles-ci sont passées par l'étape filter

#### Spécification du Deployment

Copiez la spécification suivante dans le fichier **manifests/deploy-logstash.yaml**.
Cette spécification sera utilisée pour créer un **Deployment** qui lancera l'application **logstash** dans un Pod.

```
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: logstash
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: logstash
    spec:
      containers:
      - image: logstash:5.6.8-alpine
        name: logstash
        volumeMounts:
        - mountPath: /config/logstash.conf
          name: config
        command:
        - "logstash"
        - "-f"
        - "/config/logstash.conf"
      volumes:
      - name: config
        configMap:
          name: logstash-config
```

L'unique container spécifié dans le Pod utilise une ConfigMap afin de monter le fichier de configuration logstash.conf dans son système de fichiers.

#### Spécification du Service

Copiez la spécification suivante dans le fichier **manifests/service-logstash.yaml**.
Cette spécification sera utilisée pour exposer le Pod **logstash** à l'extérieur du cluster et ainsi pouvoir lui envoyer des entrées de logs.

```
apiVersion: v1
kind: Service
metadata:
  name: logstash
spec:
  type: NodePort
  ports:
  - name: logstash
    port: 8080
    targetPort: 8080
    nodePort: 31500
  selector:
    app: logstash
```

## Création d'une ConfigMap contenant le fichier de configuration de **Logstash**.

Depuis un shell dans le répertoire **elastic**, lancez la commande suivante pour créer la configMap **logstash-config**:

```
kubectl create configmap logstash-config --from-file=./logstash.conf
```

## Déploiement de l'application

Toujours depuis un shell dans le répertoire **elastic**, lancer l'application avec la commande suivante:

```
kubectl create -f manifests/
```

## Test de l'application

Nous allons maintenant utiliser un fichier de log de test et envoyer son contenu dans Logstash, contenu qui sera donc filtrer et envoyé à Elasticsearch.

Récupérez en local le fichier nginx.log avec la commande suivante :

```
curl -s -o nginx.log https://gist.githubusercontent.com/lucj/d9f08c3e40473e0555ffb2e16f1195b1/raw
```

Ce fichier contient 500 entrées de logs au format Apache. Par exemple, la ligne suivante correspond à une requête :
- reçue le 28 septembre 2018
- de type GET
- appelant l'URL https://mydomain.net/api/object/5996fc0f4c06fb000f83b7
- depuis l'adresse IP 46.218.112.178
- et depuis un navigateur Firefox

```
46.218.112.178 - - [28/Sep/2018:15:40:04 +0000] "GET /api/object/5996fc0f4c06fb000f83b7 HTTP/1.1" 200 501 "https://mydomain.net/map" "Mozilla/5.0 (Windows NT 10.0; WOW64; rv:55.0) Gecko/20100101 Firefox/55.0" "-"
```

On utilise alors la commande suivante pour envoyer chaque ligne à **Logstash**:

```
while read -r line; do curl -s -XPUT -d "$line" http://HOST_NAME:31500 > /dev/null; done < ./nginx.log
```

Note: HOST_NAME doit être remplacé par l'adresse IP de l'une des machines du cluster.

Une fois le script terminé, l'interface de **Kibana** est disponible sur le port **31501** et il est donc possible de l'utiliser pour analyser les entrées de logs.
