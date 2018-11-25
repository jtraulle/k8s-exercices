## Exercice

Dans cet exercice vous allez créer un Pod contenant 2 containers permettant de lancer une application wordpress.

### 1. Création de la spécification

Créez un fichier yaml __wordpress_pod.yaml__ définissant un Pod ayant les propriétés suivantes:
- nom du Pod: wp
- un premier container:
  - nommé __wordpress__
  - basé sur l'image __wordpress:4.9-apache__
  - définissant la variable d'environnement __WORDPRESS_DB_PASSWORD__ avec pour valeur __mysqlpwd__ (cf note)
  - définissant la variable d'environnement __WORDPRESS_DB_HOST__ avec pour valeur __127.0.0.1__ (cf note)
- un second container:
  - nommé __mysql__
  - basé sur l'image __mysql:5.7__
  - définissant la variable d'environnement __MYSQL_ROOT_PASSWORD__ avec pour valeur __mysqlpwd__ (cf note)

Note: chaque container peut définir une clé __env__, celui contenant une liste de paires name / value

### 2. Lancement du Pod

Lancez le Pod à l'aide de __kubectl__

### 3. Vérification du status du Pod

Utilisez __kubectl__ pour vérifier l'état du Pod.

Au bout de quelques secondes, il devrait être dans l'état *Running* (le temps que les images des containers soient téléchargées depuis le DockerHub).

### 4. Accès à l'application

Forwardez le port **80** du container __wordpress__ sur le port **8080** de la machine hôte.

Lancez un navigateur sur http://localhost:8080

En ouvrant un navigateur sur l'URL indiquée, vous obtiendrez l'interface web de setup de **Wordpress**.

### 5. Suppression du Pod

A l'aide le __kubectl__ supprimez le Pod __wp__.

