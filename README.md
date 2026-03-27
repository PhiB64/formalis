
# Stack Docker Compose

Ce projet utilise **Docker Compose** pour orchestrer trois services :

- **node-app** : Application Node.js (Express)
- **mysql** : Base de données MySQL persistante
- **nginx** : Proxy inverse, sert les fichiers statiques et gère le SSL

Les volumes assurent la persistance des données MySQL et des logs applicatifs. Les certificats SSL sont montés depuis `/etc/letsencrypt`.

## Lancement

```sh
docker-compose up -d
```

## Vérification du statut des services

Pour voir l’état de santé des services :

```sh
docker-compose ps
```

Un service sain affiche `healthy` dans la colonne STATE. Si un service reste `unhealthy`, inspecte les logs du healthcheck :

```sh
docker inspect --format='{{json .State.Health}}' node-app
```

## Healthchecks

- **node-app** : `/health` doit répondre HTTP 200. Le healthcheck utilise `curl` dans le conteneur.
- **mysql** : Utilise `mysqladmin ping`.

Si le healthcheck échoue, vérifie que l’endpoint `/health` répond bien dans le conteneur :

```sh
docker exec -it node-app curl -i http://localhost:3000/health
```

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

Adapte les valeurs à ton besoin. Le fichier `.env` est déjà ignoré par `.gitignore`.
