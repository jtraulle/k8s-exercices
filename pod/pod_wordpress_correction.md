## Correction

### 1. Création de la spécification
 
La spécification, définie dans le fichier __wordpress_pod.yaml__, est la suivante:

```
apiVersion: v1
kind: Pod
metadata:
  name: wp
spec:
  containers:
  - image: wordpress:4.9-apache
    name: wordpress
    env:
    - name: WORDPRESS_DB_PASSWORD
      value: mysqlpwd
    - name: WORDPRESS_DB_HOST
      value: 127.0.0.1
  - image: mysql:5.7
    name: mysql
    env:
    - name: MYSQL_ROOT_PASSWORD
      value: mysqlpwd
```

Note: le Pod défini par la spécification ci-dessus ne permet pas de découpler les données gérées par le container **mysql** avec le cycle de vie de ce même container.
Comme nous le verrons un peu plus loin dans ce cours, nous pourrions définir un volume dans la spécification du Pod et le monter dans le container **mysql** comme cela est illustré dans la spécification ci-dessous.

```
apiVersion: v1
kind: Pod
metadata:
  name: wp
spec:
  containers:
  - image: wordpress:4.9-apache
    name: wordpress
    env:
    - name: WORDPRESS_DB_PASSWORD
      value: mysqlpwd
    - name: WORDPRESS_DB_HOST
      value: 127.0.0.1
  - image: mysql:5.7
    name: mysql
    env:
    - name: MYSQL_ROOT_PASSWORD
      value: mysqlpwd
    volumeMounts:
    - name: data
      mountPath: /var/lib/mysql
  volumes:
  - name: data
    emptyDir: {}
```


### 2. Lancement du Pod

Le Pod peut être lancé avec la commande suivante:

```
$ kubectl create -f wordpress_pod.yaml
```

### 3. Vérification du status du Pod

La commande suivante permet de voir l'état du Pod __wp__

```
$ kubectl get po/wp
```

Vous dévriez obtenir un Pod dans l'état **ContainerCreating** pendant quelques secondes, le temps que les images des containers soient téléchargées du DockerHub.

```
$ kubectl get po/wp
NAME      READY     STATUS              RESTARTS   AGE
wp        0/2       ContainerCreating   0          49s
```

Rapidement, le Pod devrait apparaitre avec le status **Running**

```
$ kubectl get pod/wp
NAME      READY     STATUS    RESTARTS   AGE
wp        2/2       Running   0          2m
```

### 4. Accès à l'application

Le container __wordpress__ tournant sur le port **80**, la commande suivante permet de forwarder ce port sur le port **8080** de l'hôte.

```
$ kubectl port-forward wp 8080:80
Forwarding from 127.0.0.1:8080 -> 80
```

### 5. Suppression du Pod

Le Pod peut être supprimé avec la commande suivante:

```
$ kubectl delete po/wp
```
