## Exercice

Dans cet exercice nous allons voir l'utilisation d'un Secret pour se connecter à une base de données externe.

### Le context

L'image **lucj/messages:1.0** contient une application simple qui permet, via des requêtes HTTP, de créer des messages ou de lister les messages existant.

Ces messages sont sauvegardés dans une base de données **MongoDB** sous-jacente dont l'URL de connexion doit être fournie à l'application de façon à ce que celle-ci puisse s'y connecter. On peut lui fournir via une variable d'environnement MONGODB_URL ou via un fichier texte accessible depuis */run/secrets/MONGODB_URL*.

### La base de données

Pour cet exercice la base de données suivante sera utilisée:
- host: **db.techwhale.io**
- port: **27017** (port par défaut de Mongo)
- nom de la base: **message**
- tls activé
- utilisateur: **k8sExercice** / **k8sExercice**

L'URL de connection est la suivante:

```
mongodb://k8sExercice:k8sExercice@db.techwhale.io:27017/message?ssl=true&authSource=admin
```

### Création du Secret

Créez un Secret, nommé **mongo**, dont le champ **data** contient la clé **mongo_url** dont la valeur est la chaine de connection spécifiée ci-dessus.

Vous avez plusieurs options pour cela:
- l'utilisation de la commande `kubectl create secret generic` avec l'option `--from-file`
- l'utilisation de la commande `kubectl create secret generic` avec l'option `--from-literal`
- l'utilisation d'un fichier de spécification

### Utilisation du Secret dans une variable d'environnement

Définissez un Pod nommé **api-env** dont l'unique container a la spécification suivante:
- nom: **api**
- image: **lucj/messages:1.0**
- une variable d'environnement **MONGODB_URL** ayant la valeur liée à la clé **mongo_url** du Secret **mongo** créé précédemment

Créez le Pod et vérifier que vous pouvez créer un message avec la commande suivante (vous pourrez utiliser `kubectl port-forward` pour exposer l'application du Pod)

```
curl -H 'Content-Type: application/json' -XPOST -d '{"from":"me", "msg":"hello"}' http://IP:PORT/messages
```

### Utilisation du Secret dans un volume

Définissez un Pod nommé **api-vol** ayant la spécification suivante:
- un volume nommé **mongo-creds** basé sur le Secret **mongo** dont la clé **mongo_url** est renommé **MONGODB_URL** (utilisation du couple (key,path) sous la clé secret/items)
- un container ayant la spécification suivante:
  - nom: **api**
  - image: **lucj/messages:1.0**
  - une instructions **volumeMounts** permettant de monter le volume **mongo-creds** sur le path **/run/secrets**

Créez le Pod et vérifier que vous pouvez créer un message.

### En Résumé

L'utilisation de Secret permet de gérer les informations sensibles à l'extérieur de l'application et de lui fournir au lancement. Comme nous l'avons vu, il y a plusieurs façons de définir et d'utiliser un Secret.
