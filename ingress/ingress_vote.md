## Exercice

Dans cet exercice, vous allez créer une ressource **Ingress** et l'utiliser pour router les requêtes vers les interfaces de vote et de result.

Cet exercice sera réalisé avec **minikube**.

### 1. Lancement de la VotingApp

De la même façon que nous l'avons fait dans un exercice précécent, clonez puis lancer la Voting App avec ls commandes suivantes:

```
$ git clone https://github.com/dockersamples/example-voting-app
$ cd example-voting-app
$ $ kubectl create -f ./k8s-specifications
```

### 2. Activation du add-on Ingress dans minikube

Utilisez une commande `minikube ...` pour activer Ingress

### 3. Ports des Service vote et result

Quels sont les ports utilisés pour exposer les micro-services **vote** et **result** à l'intérieur du cluster ?

### 4. Définition de la ressource Ingress

Créez, dans le fichier *vote_ingress.yaml*, la spécification **Ingress** permettant le routage suivant:
- **vote.votingapp.com** sur le micro-service **vote**
- **result.votingapp.com** sur le micro-service **result**

### 5. Création de la ressource Ingress

Créez la ressource précédente à l'aide de **kubectl**

### 6. Accès à l'application

Dans le fichier */etc/hosts*, assurez-vous d'avoir défini les résolutions DNS des sous-domaines **vote.votingapp.com** et **result.votingapp.com** vers l'adresse IP de minikube.

Par exemple, si l'IP de minikube (`minikube ip`) est **192.168.99.100**, vous devez ajouter les enregistrements suivants:

```
192.168.99.100  vote.votingapp.com
192.168.99.100  result.votingapp.com
```

Vous pouvez maintenant voter depuis l'interface disponible sur **http://vote.votingapp.com** et visualiser les résultats sur l'interface disponible sur **http://result.voringapp.com**.
