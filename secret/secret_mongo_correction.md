## Correction

### Création du Secret

1. Avec la commande `kubectl create secret generic` avec l'option `--from-file`

On commence par créer un fichier *mongo_url* contenant la chaine de connexion à la base de données.

```
echo -n "mongodb://k8sExercice:k8sExercice@db.techwhale.io:27017/message?ssl=true&authSource=admin" > mongo_url
```

On créé ensuite le Secret à partir de ce fichier:

```
$ kubectl create secret generic mongo --from-file=mongo_url
```

2. Avec la commande `kubectl create secret generic` avec l'option `--from-literal` 

La commande suivante permet de créer le Secret à partir de valeurs littérales

```
$ kubectl create secret generic mongo --from-literal=mongo_url='mongodb://k8sExercice:k8sExercice@db.techwhale.io:27017/message?ssl=true&authSource=admin'
```

3. En utilisant un fichier de spécification

La première étape est d'encrypter en base64 la chaine de connexion

```
$echo -n 'mongodb://k8sExercice:k8sExercice@db.techwhale.io:27017/message?ssl=true&authSource=admin' | base64

bW9uZ29kYjovL2s4c0V4ZXJjaWNlOms4c0V4ZXJjaWNlQGRiLnRlY2h3aGFsZS5pbzoyNzAxNy9tZXNzYWdlP3NzbD10cnVlJmF1dGhTb3VyY2U9YWRtaW4=
```

Ensuite on peut définir le fichier de spécification mongo-secret.yaml:

```
apiVersion: v1
kind: Secret
metadata:
  name: mongo
data:
  mongo_url: bW9uZ29kYjovL2s4c0V4ZXJjaWNlOms4c0V4ZXJjaWNlQGRiLnRlY2h3aGFsZS5pbzoyNzAxNy9tZXNzYWdlP3NzbD10cnVlJmF1dGhTb3VyY2U9YWRtaW4=
```

La dernière étape consiste à créer le Secret à partir de ce fichier

```
$ kubectl create -f mongo-secret.yaml
secret "mongo" created
```

### Utilisation du Secret dans une variable d'environnement

Nous définissons la spécification suivante dans le fichier pod_messages_env.yaml

```
apiVersion: v1
kind: Pod
metadata:
  name: api-env
spec:
  containers:
  - name: api
    image: lucj/messages:1.0
    env:
    - name: MONGODB_URL
      valueFrom:
        secretKeyRef:
          name: mongo
          key: mongo_url
```

La commande suivante permet de lancer le Pod

```
$ kubectl create -f pod_messages_env.yaml
pod "api-env" created
```

La commande suivante permet d'exposer en localhost l'API tournant dans le container du Pod

```
$ kubectl port-forward api-env 8888:80
Forwarding from 127.0.0.1:8888 -> 80
...
```

On peut alors tester le fonctionnement avec la commande suivante:

```
curl -H 'Content-Type: application/json' -XPOST -d '{"from":"me", "msg":"hey"}' http://localhost:8888/messages
{"from":"me","msg":"hey","at":"2018-04-03T12:45:07.688Z","_id":"5ac37753dfe0ee000f9b65e0"}
```

### Utilisation du Secret dans un volume

Nous définissons la spécification suivante dans le fichier pod_messages_vol.yaml

```
apiVersion: v1
kind: Pod
metadata:
  name: api-vol
spec:
  containers:
  - name: api
    image: lucj/messages:1.0
    volumeMounts:
    - name: mongo-creds
      mountPath: "/run/secrets"
      readOnly: true
  volumes:
  - name: mongo-creds
    secret:
      secretName: mongo
      items:
      - key: mongo_url
        path: MONGODB_URL
```

La commande suivante permet de lancer le Pod

```
$ kubectl create -f pod_messages_vol.yaml
pod "api-vol" created
```

La commande suivante permet d'exposer en localhost l'API tournant dans le container du Pod

```
$ kubectl port-forward api-vol 8889:80
Forwarding from 127.0.0.1:8889 -> 80
...
```

On peut alors tester le fonctionnement avec la commande suivante:

```
$ curl -H 'Content-Type: application/json' -XPOST -d '{"from":"me", "msg":"hola"}' http://localhost:8889/messages
{"from":"me","msg":"hola","at":"2018-04-03T13:05:11.408Z","_id":"5ac37c07bace38000f9b09e2"}
```
