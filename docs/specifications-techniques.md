# Spécifications techniques

## 1. Technologies utilisées

| Categorie | Technologie | Version |
|-----------|------------|---------|
| Backend | Node.js | 20 (Alpine) |
| Base de données | MySQL | 8.3 |
| Reverse proxy | NGINX | Alpine |
| Conteneurisation | Docker | - |
| Certificats SSL | Certbot (Let's Encrypt) | - |

### Dépendances Node.js

- `express`: ^5.2.1 - Framework web
- `dotenv`: ^17.3.1 - Gestion des variables d'environnement

## 2. Architecture logicielle et réseau

### Architecture des conteneurs

```
┌─────────────────────────────────────────────────────────────┐
│                     Docker Network                         │
│                     formalis-net                           │
│            (driver: bridge, réseau interne)                │
└─────────────────────────────────────────────────────────────┘
                              │
         ┌────────────────────┼────────────────────┐
         │                    │                    │
         ▼                    ▼                    ▼
    ┌─────────┐        ┌─────────────┐      ┌─────────┐
    │  NGINX  │        │  node-app   │      │  MySQL  │
    │ :80/443 │◄──────►│   :3000    │◄────►│  :3306  │
    └─────────┘        └─────────────┘      └─────────┘
         │                                      ^
         │ (ports exposés)                       │
         ▼                                      │
    Hôte: 80, 443                            (interne)
```

### Flux de communication

1. **Requêtes clientes** → NGINX (ports 80/443)
2. **NGINX** → node-app (port 3000 via proxy HTTP)
3. **node-app** → MySQL (port 3306 via connection MySQL)

### Rôle de chaque conteneur

- **NGINX**: Reverse proxy SSL, sert les fichiers statiques, redirige vers node-app
- **node-app**: Application Express (backend API)
- **MySQL**: Base de données relationnelle

## 3. Variables d'environnement nécessaires

### Fichier `.env`

| Variable | Description | Exemple |
|----------|-------------|---------|
| `NODE_ENV` | Mode d'exécution | `production` |
| `PORT` | Port de l'application Node.js | `3000` |
| `MYSQL_ROOT_PASSWORD` | Mot de passe root MySQL | `formalis123!` |
| `MYSQL_DATABASE` | Nom de la base de données | `formalis` |
| `MYSQL_USER` | Utilisateur MySQL | `formalis_user` |
| `MYSQL_PASSWORD` | Mot de passe utilisateur | `formalis123!` |

### Variables MySQL (automatiques)

| Variable | Description |
|----------|-------------|
| `MYSQL_HOST` | Hôte MySQL (nom du conteneur) |
| `MYSQL_PORT` | Port MySQL (3306) |

## 4. Ports exposés et communication entre conteneurs

### Ports exposés sur l'hôte

| Port | Service | Protocole |
|------|---------|-----------|
| 80 | HTTP | TCP |
| 443 | HTTPS | TCP |

### Communication inter-conteneurs

| Source | Destination | Port | Protocole |
|--------|-------------|------|----------|
| NGINX | node-app | 3000 | HTTP |
| node-app | mysql | 3306 | MySQL |

### Réseau Docker

- **Nom du réseau**: `formalis-net`
- **Driver**: bridge
- **Communication**: Tous les conteneurs sur le même réseau bridge peuvent communiquer entre eux via leurs noms d'hôte

## 5. Emplacement des fichiers

### Certificates SSL

```
/etc/letsencrypt/
└── live/formation.local/
    ├── fullchain.pem    (certificat + chain)
    ├── privkey.pem      (clé privée)
    └── ...
```

**Volume mounté**: `/etc/letsencrypt:/etc/letsencrypt:ro`

Le dossier certificates est monté en lecture seule (`ro`) depuis l'hôte vers le conteneur NGINX.

### Fichiers de logs

| Emplacement hôte | Contenu |
|------------------|---------|
| `./node-app/logs/` | Logs de l'application Node.js |

**Volume monté**: `./node-app/logs:/usr/src/app/logs`

### Logs Certbot

```
/var/log/certbot-renew.log
```

### Données persistantes

| Emplacement hôte | Contenu |
|------------------|---------|
| Volume Docker nommé `mysql-data` | Données MySQL (BDD) |

### Fichiers statiques

| Emplacement hôte | Contenu |
|------------------|---------|
| `./node-app/public/` | Fichiers statiques (HTML, CSS, JS) |

**Volume monté**: `./node-app/public:/usr/share/nginx/html:ro`

## 6. Configuration NGINX

### Serveur HTTP (port 80)

- Redirection permanente vers HTTPS (301)
- Server name: `formation.local`

### Serveur HTTPS (port 443)

- SSL activé avec certificats Let's Encrypt
- Protocoles: TLSv1.2, TLSv1.3
- Chiffrement: HIGH:!aNULL:!MD5

### Proxy vers node-app

```nginx
location / {
    proxy_pass http://node-app:3000;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
}
```

## 7. Santé des conteneurs (Healthcheck)

| Conteneur | Test | Intervalle | Timeout |
|-----------|------|------------|---------|
| node-app | `curl -f http://localhost:3000/health` | 30s | 5s |
| mysql | `mysqladmin ping -h localhost` | 30s | 5s |

## 8. Script de renouvellement SSL

**Emplacement**: `scripts/renew-cert.sh`

```bash
#!/bin/bash
# Renouvellement automatique du certificat Let's Encrypt
certbot renew
```

Le script doit être exécuté periódiquement via cron ou systemd timer.