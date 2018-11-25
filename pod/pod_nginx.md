## Exercice

Dans cet exercice vous allez créer votre premier Pod.

### 1. Création de la spécification

Créez un fichier yaml __www_pod.yaml__ définissant un Pod ayant les propriétés suivantes:
- nom du Pod: www
- image du container: nginx:1.12.2
- nom du container: nginx

### 2. Lancement du Pod

Lancez le Pod à l'aide de __kubectl__

### 3. Vérification

Listez les Pods lancés et assurez vous que le Pod __www__ apparait bien dans cette liste.

### 4. Details du Pod

Observez les détails du Pod à l'aide de __kubectl__ et retrouvez l'information de l'image utilisée par le container __nginx__.

### 5.Lancement d'un shell dans le container nginx

Lancez un shell dans le container __nginx__ et vérifiez la version du binaire nginx.

Note: utilisez la commande `nginx -v`.

### 6. Suppression du Pod

Toujours à l'aide de __kubectl__, supprimez le Pod.
