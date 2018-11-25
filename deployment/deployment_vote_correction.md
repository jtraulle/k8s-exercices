## Correction

### 1. Spécification d'un Deployment

La spécification, définie dans le fichier *vote_deployment.yaml* est la suivante:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: vote
spec:
  replicas: 3
  selector:
    matchLabels:
      app: vote
  template:
    metadata:
      labels:
        app: vote
    spec:
      containers:
      - name: vote
        image: instavote/vote
        ports:
        - containerPort: 80
```

### 2. Création du Deployment

La commande suivante permet de lancer le Deployment

```
$ kubectl create -f vote_deployment.yaml
```

### 3. Status du Deployment

La commande suivante permet d'obtenir le status du Deployment

```
$ kubectl get deploy
NAME          DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
vote          3         3         3            0           7s
```

On voit ici que sur les 3 replicas de Pods spécifiés (champ **DESIRED**), 3 sont actifs (champ **CURRENT**) et à jour (champ **UP-TO-DATE**).

### 4. Status des Pods accociés

La commande suivante permet de liste les Pods qui tourne sur le cluster

```
$ kubectl get po
NAME                    READY     STATUS    RESTARTS   AGE
vote-584c4c76db-2znvc   1/1       Running   0          3m
vote-584c4c76db-d62l9   1/1       Running   0          3m
vote-584c4c76db-rvjwj   1/1       Running   0          3m
```

On voit que les 3 Pods relatifs au Deployment **vote** sont listés. Ils sont tous les 3 actifs.

### 5. Exposition des Pods du Deployment

Dans un fichier *vote_service.yaml* nous créons la spécification suivante:

```
apiVersion: v1
kind: Service
metadata:
  name: vote
spec:
  selector:
    app: vote
  type: NodePort
  ports:
  - port: 80
    targetPort: 80
    nodePort: 31001
```

On la lance ensuite avec la commande:

```
$ kubectl create -f vote_service.yaml
service "vote" created
```
