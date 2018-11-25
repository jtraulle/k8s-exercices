## Exercice

Dans cet exercice, vous allez créer un Deployment et l'exposer à l'extérieur du cluster.

### 1. Spécification d'un Deployment

Créez un fichier *vote_deployment.yaml* définissant un Deployment ayant les propriétés suivantes:
- nom: **vote**
- nombre de replicas: 3
- définition d'un selector sur le label **app: vote**
- spécification du Pod:
  * label **app: vote**
  * un container nommé **vote** basé sur l'image **instavote/vote** et exposant le port **80**

### 2. Création du Deployment

Utilisez **kubectl** pour créer le Deployment

### 3. Status du Deployment

A l'aide de **kubectl**, examinez le status du Deployment **vote**.

A partir de ces informations, que pouvez-vous dire par rapport au nombre de Pods géré par ce Deployment ?

### 4. Status des Pods associés

A l'aide de **kubectl**, lister les Pods associés à ce Deployment.

### 5. Exposition des Pods du Deployment

Créez un Service qui permettant d'exposer les Pods du Deployment à l'extérieur du cluster

Conseils:

- vous pourrez commencer par créer une spécification pour le Service, en spécifiant que le **selector** doit permettre de regrouper les Pods ayant le label **app: vote**.

- le service devra être de type **NodePort**, vous pourrez par exemple le publier sur le port **31001** sur le cluster

- le container basé sur l'image **instavote/vote** tourne sur le port **80**, ce port devra donc être référencé en tant que **targetPort** dans la spécification du Service.

Note: n'hésitez pas à vous reportez à l'exercice sur les Services de type NodePort que nous avons vu précédemment.

Une fois le service créé, vous pourrez accèder à l'interface de vote servie par les containers des Pods du Deployment sur *http://IP:31001* ou IP est l'adresse IP d'une machine du cluster Kubernetes.

Attention: cette interface n'est pour le moment pas branchée à un backend, il n'est pas encore possible de voter, si vous cliquez sur l'un des choix, vous obtindrez une erreur. Nous reviendrons sur cette application de vote dans sa totalité très bientôt.

![Interface de vote](./images/deployment_vote.png)
