## Exercice

Dans cet exercice vous allez déployer la Voting App, application de vote très souvent utilisée pour les démos et présentation

### 1. Récupération du projet

Cloner le repository avec la commande suivante

```
$ git clone https://github.com/dockersamples/example-voting-app
$ cd example-voting-app
```

### 2. Création des ressources

Dans le répertoire **k8s-specifications** se trouvent l'ensemble des spécifications des ressources.

Examinez chacun des fichiers de spécification, quelles sont les ressources en jeu pour chaque micro-service ?

Avec **kubectl** créer l'ensemble de ces ressources en une seule fois.

### 3. Liste des ressources

Listez les différentes ressources créées.

### 4. Accès à l'application

Lancez un navigateur sur l'interface de vote.

Note: l'IP est celle de minikube, le port est défini dans la spécification du Service **vote**

Sélectionnez une option et visualisez le résultat dans l'interface **result**.
