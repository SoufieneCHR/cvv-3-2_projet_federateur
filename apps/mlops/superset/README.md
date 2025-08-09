Apache Superset

Introduction
Apache Superset est une plateforme de visualisation et d'exploration de données open-source. Conçue pour être intuitive, puissante et évolutive, elle permet aux utilisateurs de créer et partager des tableaux de bord interactifs, explorer des ensembles de données et exécuter des requêtes SQL. Apache Superset est compatible avec une large gamme de bases de données SQL et d'entrepôts de données.


I-	Installation et configuration d'Apache Superset dans Kubernetes

Pour installer Apache Superset dans Kubernetes, nous pouvons suivre ces étapes. Apache Superset est une application Web de business intelligence moderne et adaptée aux entreprises que nous pouvons déployer à l'aide de Helm Chart ou en créant manuellement des ressources Kubernetes. 
Durant ce projet nous allons utiliser la méthode Helm Chart de Bitnami pour l’installation.

Les Helm Charts de Bitnami sont des packages préconfigurés pour déployer des applications sur Kubernetes. Ils simplifient la gestion des ressources Kubernetes en regroupant tout ce dont nous avons besoin pour déployer une application, comme des fichiers de configuration et des dépendances.

Installer Superset dans Kubernetes implique plusieurs étapes, notamment la préparation du cluster, la configuration de la base de données backend et l'intégration des composants nécessaires.

Préparation de la machine virtuelle :
Augmentation du CPU et de la Mémoire.
 

Prérequis :
Avant de commencer, nous devons avoir installé Docker, Kind, Helm, et kubectl. 

1. Installer Docker
 Sur Linux
1.	Mise à jour des paquets existants :
sudo apt-get update
2.	Installation des dépendances nécessaires :
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
3.	Ajout de la clé GPG officielle de Docker :
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
4.	Ajout du dépôt Docker pour Ubuntu :
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
5.	Mise à jour des sources des paquets et installallation Docker :
sudo apt-get update
sudo apt-get install docker-ce
6.	Vérification de l'installation de Docker :
docker –version

 

2. Installer Kind (Kubernetes IN Docker)
Sur Linux
1.	Téléchargement de Kind à partir de GitHub et installation :
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.18.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
2.	Vérification que Kind est installé correctement :
kind –version

 


3. Installer Helm
 Sur Linux
1.	Téléchargement de la dernière version de Helm :
curl https://get.helm.sh/helm-v3.11.1-linux-amd64.tar.gz -o helm.tar.gz
tar -zxvf helm.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
2.	Vérification de l'installation de Helm :
helm version

 

4. Installer kubectl
 Sur Linux
1.	Téléchargement du fichier binaire de kubectl :
curl -LO "https://dl.k8s.io/release/v1.24.0/bin/linux/amd64/kubectl"
2.	Le rendre exécutable :
chmod +x ./kubectl
3.	Déplacement du fichier dans un répertoire dans notre PATH :
sudo mv ./kubectl /usr/local/bin/kubectl
4.	Vérification de l'installation :
kubectl version –client

 
Les étapes d'installation:

Étape 1 : Créer un cluster Kubernetes avec Kind
1.	Créer un cluster Kubernetes local avec Kind :
kind create cluster --name superset

2.	Vérifier que le cluster est opérationnel :
kubectl cluster-info 

Étape 2 : Installer Helm
1.	Vérifier que Helm est installé :
helm version

2.	Ajouter le dépôt Helm de Bitnami (pour accéder aux charts de Bitnami):
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

Étape 3 : Créer un namespace Kubernetes pour Superset
1.	Créer un namespace superset pour organiser les ressources Kubernetes:
kubectl create namespace superset

Étape 4 : Installer Apache Superset avec Helm
1.	Installer Superset à l’aide de Helm dans le namespace superset :
helm install superset bitnami/superset --namespace superset

Cela va télécharger le chart d’Apache Superset et l'installer dans notre cluster Kubernetes local.

2.	Vérifier l'installation de Superset :
Après l'installation, nous pouvons vérifier que les pods sont bien créés :
kubectl get pods -n superset

Cela doit afficher les pods associés à Superset en état Running (en cours d'exécution).

Étape 5 : Accéder à l’interface web de Superset
1.	Utiliser kubectl port-forward pour exposer le service Superset sur le port 8088 de notre machine locale :
kubectl port-forward svc/superset-web 8088:80 -n superset

2.	Accéder à Superset via le navigateur :
Ouvrons un navigateur web et allons à l'adresse suivante :
http://localhost:8088

Étape 6 : Se connecter à Superset
1.	Se connecter avec les identifiants par défaut :
Lorsque nous accèdons à Superset pour la première fois, utilisons ces identifiants par défaut :
o	Nom d'utilisateur : admin
o	Mot de passe : bitnami
Une fois connecté, nous pourrons commencer à configurer Superset et à ajouter des sources de données.

Étape 7 : Personnaliser l'installation :
Nous pouvons personnaliser l'installation, comme définir un mot de passe différent pour l'administrateur ou d'autres configurations, pour cela nous allons utiliser un fichier values.yaml
1.	Créer un fichier values.yaml personnalisé :
Modification du mot de passe Administrateur et du mot de passe de la base de données PostgreSQL :
Exemple de values.yaml :
postgresql:
  postgresqlPassword: "supersecretpassword"
superset:
  adminPassword: "newadminpassword"

3.	Installer ou mettre à jour Superset avec le fichier values.yaml personnalisé :
Pour appliquer ces personnalisations après l'installation initiale, utilisons cette commande pour mettre à jour Superset :
helm upgrade --install superset bitnami/superset --namespace superset -f values.yaml

Vérification des Secrets dans Kubernetes :

Lister les secrets dans le namespace de Superset :
Exécutons la commande suivante pour lister tous les secrets dans le namespace où Superset est déployé :
kubectl get secrets -n superset
Cela te donnera une liste de tous les secrets dans ce namespace.
 
Vérification des contenus des secrets
Pour vérifier si le mot de passe est stocké dans l'un de ces secrets, nous pouvons utiliser les commandes suivantes pour inspecter les secrets en détail et voir si le mot de passe y est stocké (sous forme de base64). Commençons par inspecter le secret superset-postgresql 

kubectl get secret superset-postgresql -n superset -o yaml
Cela affichera les données du secret en YAML. 
 
Décoder le mot de passe PostgreSQL :
Nous pouvons décoder le mot de passe PostgreSQL avec la commande suivante :
echo "VmtLU0IzUVpCdA==" | base64 --decode
Cela donnera le mot de passe en texte clair pour l'utilisateur PostgreSQL : VkKSB3QZBt
 
En cas ou le secret n’existe pas nous pouvons le créer pour PostgreSQL :
kubectl create secret generic superset-postgresql \
  --from-literal=password=VkKSB3QZBt \
  -n superset
 

Vérification du secret superset-redis :
kubectl get secret superset-redis -n superset -o yaml
Cela montrera les données liées à Redis
 
Décoder le mot de passe Redis :
Pour le mot de passe Redis, nous pouvons utiliser la commande suivante :
echo "bmtMbWZIVEQ1Qg==" | base64 --decode
Cela donnera le mot de passe en texte clair pour Redis : nkLmfHTD5B
 
Utilisons la commande suivante pour créer un secret Redis avec un mot de passe, dans le cas ou le secret n’existe pas :
kubectl create secret generic superset-redis \
  --from-literal=redis-password=nkLmfHTD5B \
  -n superset
 

Mise à jour de values.yaml pour utiliser ces secrets

Voici comment mettre à jour les sections correspondantes dans le fichier values.yaml :
Pour PostgreSQL :
Si nous voulons utiliser le secret superset-postgresql, il faut mettre à jour le fichier values.yaml pour pointer vers ce secret :
postgresql:
  auth:
    enablePostgresUser: true
    username: bn_superset
    password: ""  # Tu laisses vide car le mot de passe sera pris du secret
    existingSecret: "superset-postgresql"  # Indiquer le nom du secret
    existingSecretPasswordKey: "password"  # Utilise la clé `password` du secret
    database: bitnami_superset

 

Pour Redis :
Pour Redis, mettre à jour la section correspondante du fichier values.yaml pour utiliser le secret superset-redis :
redis:
  enabled: true
  auth:
    enabled: true
    password: ""  # Laisse vide car le mot de passe sera pris du secret
    existingSecret: "superset-redis"  # Indiquer le nom du secret Redis
    existingSecretPasswordKey: "redis-password"  # Utilise la clé `redis-password` du secret
  architecture: standalone
  master:
    service:
      ports:
        redis: 6379
  resourcesPreset: "nano"
  resources: {}

 

Redéploiement de Superset avec les nouvelles configurations : 

helm upgrade superset bitnami/superset -f values.yaml -n superset

Cela mettra à jour le déploiement Superset avec les secrets et les mots de passe corrects.
 
Obtenir les identifiants de connexion à Superset : 
La commande suivante permet de récupérer le mot de passe de Superset qui est stocké dans le secret Kubernetes :
export SUPERSET_PASSWORD=$(kubectl get secret --namespace "superset" superset -o jsonpath="{.data.superset-password}" | base64 -d)
echo "User: user"
echo "Password: $SUPERSET_PASSWORD"

 
Cela donnera les informations de connexion par défaut :
•	Utilisateur : user => user
•	Mot de passe : Ce sera le mot de passe récupéré depuis le secret. => VFkTCCjq78

 
 

Finalisation de l’installation
Connexion ou conteneur Superset Web pour lancer les commandes dans l’ordre:
kubectl exec -it superset-web-7db5bf7769-n86h8 -n superset -- /bin/bash
# initialize the database
$ superset db upgrade
# Create an admin user in your metadata database (use `admin` as username to be able to load the examples)
$ superset fab create-admin

# Load some data to play with
$ superset load_examples

# Create default roles and permissions
$ superset init


Étape 8 : Désinstaller Superset (si nécessaire)
Si nous voulons supprimer Superset et toutes ses ressources, nous pouvons désinstaller le chart Helm :
1.	Désinstaller Superset :
helm uninstall superset --namespace superset
Cela supprimera Superset du cluster Kubernetes.
2.	Supprimer le dépôt Bitnami :
helm repo remove bitnami
helm repo update
3.	Supprimer le namespace superset :
kubectl delete namespace superset


II-	Utilisation détaillée d'Apache Superset après l'installation

Étape 1 : Connexion initiale
1.	Accéder à Superset :
o	Accès à l’URL: 
http://localhost:8088 

2.	Interface utilisateur :
o	Exploration de l’interface, qui est divisée en plusieurs sections : Dashboards, Charts, Datasets, et Databases.

Étape 2 : Configuration d’une connexion à une base de données
Pour commencer à explorer et visualiser des données, connectons-nous à une base de données source.
1.	Dans la section Bases de données :
o	Accès à Settings > Database Connections.
o	Cliquer sur + Add Database.

2.	Configurer la connexion :
o	Sélection du type de base de données (PostgreSQL).
o	Fournir les détails de connexion :
o	URI de la base de données : Par exemple : postgresql+psycopg2://username:password@hostname:port/database
postgresql+psycopg2://bn_superset:VkKSB3QZBt@superset-postgresql:5432/bitnami_superset

3.	Tester la connexion :
o	Cliquez sur Test Connection.
o	Si la connexion est réussie, sauvegardez.

4.	Ajout des données dans la base de données :
Chargement des données CSV
raw.githubusercontent.com/apache-superset/examples-data/master/tutorial_flights.csv
   Téléchargeons le fichier CSV sur notre ordinateur à partir de GitHub. Dans le menu principal, sélectionnez Settings ‣ Data ‣ Database Connections. Ensuite, choisissez Upload file to database ‣ Upload CSV.
 

Étape 3 : Création d’un dataset
Un dataset est une vue ou une table provenant de notre base de données connectée.
1.	Créer un dataset :
o	Accès à Datasets > + Dataset.
o	Sélection de la base de données source et la table ou requête SQL.
2.	Configurer le dataset :
o	Ajout des métadonnées comme des colonnes, des filtres par défaut, ou des labels.
o	Sauvegardez.
Dataset tutorial_flights


Étape 4 : Création de Charts
Les charts sont créés à partir des datasets.
1.	Créer un chart :
o	Aller dans Charts > + Chart.
o	Choisissons une source de données (dataset) et un type de visualisation (barres, lignes, cartes, etc.).
2.	Configurer les paramètres :
o	Définissons les axes, filtres, mesures, et autres paramètres de visualisation.
o	Sauvegarder le chart.


Étape 5 : Création de tableaux de bord (Dashboards)
Les tableaux de bord regroupent plusieurs charts pour une vue unifiée.
1.	Créer un tableau de bord :
o	Accès à Dashboards > + Dashboard.
o	Donnons un nom et ajoutons une description (optionnelle).
2.	Ajouter des graphiques au tableau de bord :
o	Glisser-déposer des charts existants dans le tableau de bord.
o	Organiser les charts en fonction des besoins.
3.	Configurer et publier :
o	Ajout des filtres globaux, des annotations ou des informations contextuelles.
o	Publication du tableau de bord pour le rendre accessible aux autres utilisateurs.
  

Étape 6 : Gestion des utilisateurs et des permissions
Superset offre des rôles et permissions pour gérer l'accès.
1.	Créer des utilisateurs :
o	Utilisation de l’interface ou la CLI pour ajouter de nouveaux utilisateurs, exemple :
kubectl exec -it <superset-pod-name> -n superset -- superset fab create-user \
  --username <username> --firstname <firstname> --lastname <lastname> \
  --email <email> --role <role> --password <password>
2.	Configurer les rôles :
o	Accès à Settings > Roles.
o	Création ou modification des rôles pour restreindre l’accès à certains tableaux de bord, bases de données ou graphiques.


Étape 7 : Fonctionnalités avancées
a) Extensions et plugins
1.	Installation des extensions ou développement des plugins pour ajouter des types de visualisation ou des fonctionnalités.
2.	Compilation des plugins et redéploiement Superset.
b) Monitoring et logs
1.	Accès aux logs via Kubernetes :
kubectl logs -f <superset-pod-name> -n superset
2.	Intégration avec Prometheus ou Grafana pour surveiller les métriques de Superset.

Étape 8 : Maintenance
1.	Vérification de la version actuelle de Superset : helm list –n superset
2.	Sauvegarde des données et des configurations.
3.	Vérification de la disponibilité de la nouvelle version de Superset.
helm search repo bitnami/superset --version <version>
4.	Mise à jour du chart Helm avec la commande helm upgrade.
5.	Exécution des migrations de base de données avec superset db upgrade.
6.	Redémarrage des pods Superset avec kubectl rollout restart.
7.	Vérification du bon fonctionnement de l’application. 
kubectl logs -f <superset-pod> -n superset
8.	Effectuer un nettoyage des ressources obsolètes (optionnel).
Environnement de staging :
•	Il faut s’assurer de tester la mise à jour dans un environnement de staging ou de test avant de la déployer en production.
•	En cas de problème, nous pouvons revenir à la version précédente en utilisant helm rollback :

helm rollback <release-name> <revision-number> -n superset
Cela permettra de mettre à jour Superset efficacement tout en maintenant les données intactes.

	Ces étapes couvrent l’utilisation courante et avancée de Superset après son installation dans Kubernetes.

Conclusion finale :
L'installation et la configuration d’Apache Superset sont relativement simples, surtout avec l’utilisation des outils comme Helm pour gérer le déploiement sur Kubernetes. Superset est un outil puissant pour l'analyse et la visualisation de données, offrant une grande flexibilité grâce à son interface utilisateur, ses intégrations multiples et ses capacités d'extensibilité.


Bibliographie

•	Site officiel Apache Superset : https://superset.apache.org/
•	Documentation GitHub : https://github.com/apache/superset/tree/master/docs
•	Communauté et support : https://github.com/apache/superset/discussions



