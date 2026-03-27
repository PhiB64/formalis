# Dockerfile pour l'application Node.js
FROM node:20-alpine

# Dossier de travail
WORKDIR /usr/src/app


# Installation de curl pour le healthcheck
RUN apk add --no-cache curl

# Copie des fichiers package.json et package-lock.json
COPY package*.json ./

# Installation des dépendances
RUN npm install --production

# Copie du code source
COPY . .

# Exposition du port
EXPOSE 3000

# Commande de démarrage
CMD ["npm", "start"]
