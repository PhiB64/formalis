# FORMALIS: Plateforme e-learning – Stack Docker

Ce projet propose une plateforme e-learning conteneurisée avec :
- **Node.js** (API backend)
- **MySQL** (base de données)
- **NGINX** (reverse proxy + SSL)
- Orchestration via **Docker Compose**

## Lancement rapide

```bash
docker-compose up -d
```

## Configuration

- Variables d’environnement à renseigner dans `.env` (voir exemples dans la documentation).
- Les ports exposés : 3000 (API), 3306 (MySQL), 80/443 (NGINX).
- Accès à la base possible via DBeaver (voir rapport de validation).

## Documentation

- [Rapport de validation](docs/rapport-validation.md) : fonctionnement, captures, checklist
- [Spécifications fonctionnelles](docs/specifications-fonctionnelles.md)
- [Spécifications techniques](docs/specifications-techniques.md)
- [Exports MCD/MLD](docs/formalis_mcd.png), [MLD](docs/formalis_mld.png)

Pour toute procédure détaillée, consulte le dossier [docs/](docs/).
