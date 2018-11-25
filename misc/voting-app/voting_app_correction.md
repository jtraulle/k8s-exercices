## Correction

### 2. Création des ressources

Pour chaque micro-service de l'application, il y a un Deployment et un Service. Seul le micro-service **worker** n'a pas de Service associé car il n'est pas exposé dans le cluster.

La commande suivante permet de créer l'ensemble des ressources en même temps

```
$ kubectl create -f ./k8s-specifications
deployment "db" created
service "db" created
deployment "redis" created
service "redis" created
deployment "result" created
service "result" created
deployment "vote" created
service "vote" created
deployment "worker" created
```

### 3. Liste des ressources

La commande suivante permet de lister les Deployements, Pods et Services créés.

```
$ kubectl get deplpy,pod,svc
NAME            DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deploy/db       1         1         1            1           1m
deploy/redis    1         1         1            1           1m
deploy/result   1         1         1            1           1m
deploy/vote     1         1         1            1           1m
deploy/worker   1         1         1            1           1m

NAME                         READY     STATUS    RESTARTS   AGE
po/db-549c4694d9-td9gj       1/1       Running   0          1m
po/redis-5ff865c7d-bxhd9     1/1       Running   0          1m
po/result-76784c98fb-4mq57   1/1       Running   0          1m
po/vote-65df68d6ff-ghcbv     1/1       Running   0          1m
po/worker-8875fdcc8-zbxl2    1/1       Running   0          1m

NAME             TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
svc/db           ClusterIP   10.99.192.60    <none>        5432/TCP         1m
svc/redis        ClusterIP   10.111.62.16    <none>        6379/TCP         1m
svc/result       NodePort    10.107.254.26   <none>        5001:31001/TCP   1m
svc/vote         NodePort    10.99.171.171   <none>        5000:31000/TCP   1m
```

### 4. Accès à l'application

L'interface de vote est disponible sur le port **31000**

![vote](./images/vote1.png)

L'interface de result est disponible sur le port **31001**

![result](./images/vote2.png)
