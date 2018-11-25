## Exercice

Dans cet exercice, vous allez créer un Deployment et effectuer un rolling update.

### 1. Création d'un Deployment

A l'aide de la commande `kubectl run`, créez un Deployment avec les propriétés suivantes:
- nom: **www**
- 3 replicas d'un Pod avec un container basé sur nginx:1.11.13

Spécifiez l'option **--record=true** à la fin de la commande afin de conserver l'historique des commandes de mises à jour du Deployment.

### 2. Liste des ressources

Listez les ressources créées par la commande précédente (Deployment, ReplicaSet, Pod).

Note: utilisez une seule fois la commande **kubectl** pour lister l'ensemble des ressources.

### 3. Mise à jour de l'image

Mettez l'image nginx à jour avec la version 1.12.2

### 4. Liste des ressources

Une nouvelle fois, listes les ressource.

Que constatez vous ?

### 5. Historique des mises à jour

Listez les mises à jour (= révisions) du Deployment.

Note: utilisez la commande `kubectl rollout...`
