# Rapport de validation

## 1. Démarrage des conteneurs

- Commande : `docker-compose up -d`
- Vérification :
  - `docker ps` montre les conteneurs node-app, mysql, nginx en statut Up
 
![Vérification Démarrage](image-3.png)

## 2. Test de l’API via HTTPS

- Commande : `curl -k https://formation.local/health`
- Résultat attendu : `OK`
![Test API](image-1.png)

## 3. Vérification du reverse proxy NGINX

- NGINX expose les ports 80/443
- Redirige bien vers node-app
- Certificats montés depuis /etc/letsencrypt
![Montage](image-2.png)

## 4. Connexion Node ↔ MySQL

- Test de connexion effectué dans node-app
- Résultat : OK ou message d’erreur explicite
![Test connexion node-app](image-4.png)

## 5. Renouvellement automatique du certificat

- Script Bash présent dans scripts/renew-cert.sh
![Script](image.png)

## 6. Accès à la base de données via DBeaver

- Connexion réussie à la base MySQL via DBeaver (localhost:3306)
- Paramètre JDBC utilisé : `allowPublicKeyRetrieval=true`

![Connexion DBeaver](formalis_DBeaver.png)


