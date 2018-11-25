## Exercice

Le but de cet exercice est de manipuler les namespaces et de comprendre comment les utiliser pour isoler les ressources

### 1. Création

Créez les 2 namespaces **development** et **production**

### 2. Liste des namespaces

Listez les namespaces présent

### 3. Création de Deployments

Créer le Deployment **www-0** basé sur nginx:1.12.2 dans le namespace par défaut

Créer le Deployment **www-1** basé sur nginx:1.12.2 dans le namespace **development**

Créer le Deployment **www-2** basé sur nginx:1.12.2 dans le namespace **production**

### 4. Répartition des ressources

Listez les Deployments et Pods présents sur le système (l'option `--all-namespaces` permet de prendre en compte l'ensemble des namespaces)

### 5. Suppression

Supprimez les namespaces **development** et **production**

Listez une nouvelle fois les Deployments et Pods présent sur le système. Que constatez-vous ?

Note: comme nous le verrons par la suite, il est possible de définir des règles permettant de donner accès à des actions précises dans un namespace. Cette approche permet d'utiliser les namespaces pour isoler les ressources du cluster entre plusieurs équipes (dev, qa, prod) et/ou plusieurs clients.
