
# Stack Docker Compose

Ce projet utilise **Docker Compose** pour orchestrer trois services :

- **node-app** : Application Node.js (Express)
- **mysql** : Base de données MySQL persistante
- **nginx** : Proxy inverse, sert les fichiers statiques et gère le SSL

Les volumes assurent la persistance des données MySQL et des logs applicatifs. Les certificats SSL sont montés depuis `/etc/letsencrypt`.

# Variables d’environnement nécessaires

À placer dans un fichier `.env` à la racine du projet :

```
MYSQL_ROOT_PASSWORD=...
MYSQL_DATABASE=...
MYSQL_USER=...
MYSQL_PASSWORD=...
NODE_ENV=development
PORT=3000
```

Adaptez les valeurs. Le fichier `.env` est déjà ignoré par `.gitignore`.


## Lancement

```sh
docker-compose up -d
```

## Vérification du statut des services

Pour voir l’état de santé des services :

```sh
docker-compose ps
```

Un service sain affiche `healthy` dans la colonne STATE. Si un service reste `unhealthy`, inspectez les logs du healthcheck :

```sh
docker inspect --format='{{json .State.Health}}' node-app
```

## Healthchecks

- **node-app** : `/health` doit répondre HTTP 200. Le healthcheck utilise `curl` dans le conteneur.
- **mysql** : Utilise `mysqladmin ping`.

Si le healthcheck échoue, vérifiez que l’endpoint `/health` répond bien dans le conteneur :

```sh
docker exec -it node-app curl -i http://localhost:3000/health
```

# Logs & debugging

## Consulter les logs des conteneurs

Pour afficher les logs d’un service (exemple pour node-app) :

```sh
docker logs node-app
```

Pour suivre les logs en temps réel :

```sh
docker logs -f node-app
```

## Redirection des logs applicatifs

Les logs générés par l’application Node.js sont redirigés vers le dossier `./node-app/logs` sur l’hôte grâce au volume :

```yaml
		volumes:
			- ./node-app/logs:/usr/src/app/logs
```

Cela permet de consulter les logs même si le conteneur est supprimé.

## Nettoyage et suppression

Pour arrêter les conteneurs sans supprimer les données :

```sh
docker-compose stop
```

Pour arrêter et supprimer les conteneurs (mais garder les volumes persistants) :

```sh
docker-compose down
```

Pour tout supprimer, y compris les volumes (perte IRRÉVERSIBLE des données MySQL) :

```sh
docker-compose down -v
```

**Attention** : la suppression des volumes efface toutes les données de la base MySQL et les logs persistés.

	
# HTTPS local avec certificat auto-signé

## Générer un certificat auto-signé pour formation.local

1. Créez le dossier cible (simule la structure Let’s Encrypt) :
```sh
sudo mkdir -p /etc/letsencrypt/live/formation.local/
```
2. Génèrez la clé privée :
```sh
sudo openssl genrsa -out /etc/letsencrypt/live/formation.local/privkey.pem 2048
```
3. Génèrez le certificat auto-signé :
```sh
sudo openssl req -new -x509 -key /etc/letsencrypt/live/formation.local/privkey.pem \
	-out /etc/letsencrypt/live/formation.local/fullchain.pem -days 365 \
	-subj "/CN=formation.local"
```
4. Vérifiez la présence des fichiers :
```sh
ls -l /etc/letsencrypt/live/formation.local/
# Vous devez voir privkey.pem et fullchain.pem
```

## Montage du certificat dans NGINX (Docker)

Dans `docker-compose.yml`, le dossier `/etc/letsencrypt` de l’hôte est monté en lecture seule dans le conteneur NGINX :
```yaml
	volumes:
	  - /etc/letsencrypt:/etc/letsencrypt:ro
```


## Configuration NGINX pour HTTPS

Le fichier de configuration NGINX (`nginx/nginx.conf`) fourni dans ce projet est déjà prêt pour :
- Activer le HTTPS avec les certificats générés
- Rediriger automatiquement le HTTP vers le HTTPS
- Faire le proxy des requêtes vers le backend Node.js

Assurez-vous de générer les certificats et de monter le dossier `/etc/letsencrypt` comme indiqué ci-dessus.

## Tester l’accès HTTPS

Ajoutez dans `/etc/hosts` sur votre machine :
```
127.0.0.1   formation.local
```

Puis testez :
```sh
curl -vk https://formation.local/health
```
L’option `-k` permet d’accepter le certificat auto-signé. Vous devez obtenir HTTP 200 OK.

