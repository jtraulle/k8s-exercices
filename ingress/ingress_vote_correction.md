## Correction

### 2. Activation du add-on Ingress dans minikube

La commande suivante permet d'activer Ingress

```
$ minikube addons enable ingress
```

### 3. Ports des Service vote et result

La commande suivante liste les services existants

```
$ kubectl get svc
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
db           ClusterIP   10.99.192.60    <none>        5432/TCP         36m
kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP          16h
redis        ClusterIP   10.111.62.16    <none>        6379/TCP         36m
result       NodePort    10.107.254.26   <none>        5001:31001/TCP   36m
vote         NodePort    10.99.171.171   <none>        5000:31000/TCP   36m
```

Nous pouvons voir que le Service **vote** expose le port **5000** à l'intérieur du cluster, et le port **31000** à l'extérieur.

De la même façon, nous voyons que le Service **result** expose le port **5001** à l'intérieur du cluster, et le port **31001** à l'extérieur.

Note: nous pouvons également obtenir ces informations depuis les fichiers de spécifications des Services de **vote** et **result**.

### 4. Définition de la ressource Ingress

Le fichier *vote_ingress.yaml* contient la spécification suivante:

```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: voting-domain
  namespace: vote
spec:
  rules:
  - host: vote.votingapp.com
    http:
      paths:
      - path: /
        backend:
          serviceName: vote
          servicePort: 5000
  - host: result.votingapp.com
    http:
      paths:
      - path: /
        backend:
          serviceName: result
          servicePort: 5001
```

Nous définissons 2 **rules**:
- la première spécifie que les requêtes qui arrivent sur **http://vote.votingapp.com** sont forwardées sur le port **5000** du Service nommé **vote**
- la seconde spécifie que les requêtes qui arrivent sur **http://result.votingapp.com** sont forwardées sur le port **5001** du Service nommé **result**

### 5. Création de la ressource Ingress

La commande suivante permet de créer la ressource définie dans le fichier *vote_ingress.yaml*

```
$ kubectl create -f vote_ingress.yaml
ingress "voting-domain" created
```

### 6. Accès à l'application

L'interface de vote est disponible sur **http://vote.votingapp.com**.

![vote](./images/ingress_vote1.png)

L'interface de resultats est disponible sur **http://result.votingapp.com**.

![result](./images/ingress_vote2.png)
