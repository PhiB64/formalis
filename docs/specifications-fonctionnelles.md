# Spécifications fonctionnelles

## 1. Gestion des utilisateurs

### 1.1 Création de compte

| Élément | Description |
|---------|-------------|
| **Rôle** | Administrateur |
| **Description** | Création d'un nouveau compte utilisateur avec email unique, mot de passe et rôle assigné |
| **Résultat** | Compte utilisateur créé et disponible pour connexion |

### 1.2 Inscription autonome

| Élément | Description |
|---------|-------------|
| **Rôle** | Apprenant potentiel |
| **Description** | Auto-inscription avec email, mot de passe et choix du rôle par défaut (apprenant) |
| **Résultat** | Compte apprenant créé avec état "en attente de validation" |

### 1.3 Attribution des rôles

| Élément | Description |
|---------|-------------|
| **Rôle** | Administrateur |
| **Description** | Attribution du rôle : apprenant, formateur ou administrateur |
| **Résultat** | Droits d'accès mis à jour selon le nouveau rôle |

### 1.4 Modification du profil

| Élément | Description |
|---------|-------------|
| **Rôle** | Tous les utilisateurs |
| **Description** | Mise à jour des informations personnelles (nom, prénom, email, mot de passe) |
| **Résultat** | Profil mis à jour dans la base de données |

---

## 2. Consultation des cours et des chapitres

### 2.1 Parcours du catalogue

| Élément | Description |
|---------|-------------|
| **Rôle** | Tous les utilisateurs (connectés ou non) |
| **Description** | Navigation dans le catalogue des cours avec filtres par catégorie, niveau et prix |
| **Résultat** | Liste des cours disponibles affichée |

### 2.2 Consultation du détail d'un cours

| Élément | Description |
|---------|-------------|
| **Rôle** | Apprenant, Formateur, Administrateur |
| **Description** | Affichage de la page complète d'un cours : description, chapitres, leçons, ressources |
| **Résultat** | Contenu complet du cours visible |

### 2.3 Lecture d'une leçon

| Élément | Description |
|---------|-------------|
| **Rôle** | Apprenant inscrit au cours |
| **Description** | Accès au contenu d'une leçon (texte, vidéo, documents) avec possibilité de marquer comme complétée |
| **Résultat** | Contenu affiché, progression mise à jour |

### 2.4 Recherche de cours

| Élément | Description |
|---------|-------------|
| **Rôle** | Tous les utilisateurs |
| **Description** | Recherche par mot-clé, catégorie, tag ou niveau |
| **Résultat** | Résultats de recherche filtrés |

---

## 3. Téléversement de ressources et de devoirs

### 3.1 Création d'un cours

| Élément | Description |
|---------|-------------|
| **Rôle** | Formateur, Administrateur |
| **Description** | Création d'un nouveau cours avec titre, description, niveau, prix et catégorie |
| **Résultat** | Cours créé avec état "brouillon" en attente de publication |

### 3.2 Ajout de chapitres et leçons

| Élément | Description |
|---------|-------------|
| **Rôle** | Formateur (auteur du cours), Administrateur |
| **Description** | Ajout de chapitres structurés avec leçons (titre, contenu, durée, type) |
| **Résultat** | Structure pédagogique du cours créée |

### 3.3 Ajout de ressources

| Élément | Description |
|---------|-------------|
| **Rôle** | Formateur (auteur du cours), Administrateur |
| **Description** | Téléversement de fichiers (PDF, vidéo, images) attachés aux leçons |
| **Rendu** | Ressources disponibles en téléchargement pour les apprenants |

### 3.4 Création de devoirs

| Élément | Description |
|---------|-------------|
| **Rôle** | Formateur (auteur du cours), Administrateur |
| **Description** | Création d'un devoir avec instructions, date limite et type de soumission |
| **Résultat** | Devoir publié et visible pour les apprenants inscris |

### 3.5 Soumission de devoirs

| Élément | Description |
|---------|-------------|
| **Rôle** | Apprenant inscrit au cours |
| **Description** | Téléversement de fichier ou soumission textuelle |
| **Résultat** | Devoir soumis avec horodatage et confirmtion |

---

## 4. Évaluations et notation

### 4.1 Notation d'un cours

| Élément | Description |
|---------|-------------|
| **Rôle** | Apprenant ayant terminé le cours |
| **Description** | Dépôt d'un avis avec note (1-5 étoiles) et commentaire |
| **Résultat** | Note et avis visibles sur la page du cours (1 seul par utilisateur) |

### 4.2 Correction des devoirs

| Élément | Description |
|---------|-------------|
| **Rôle** | Formateur (auteur du cours), Administrateur |
| **Description** | Évaluation des devoirs soumis avec annotation, note et commentaire |
| **Résultat** | Note enregistrée et communiquée à l'apprenant |

### 4.3 Questions et réponses

| Élément | Description |
|---------|-------------|
| **Rôle** | Apprenant inscrit, Formateur, Administrateur |
| **Description** | Pose de questions sur une leçon, réponses en thread |
| **Résultat** | Discussion interactive associée au cours |

### 4.4 Suivi de progression

| Élément | Description |
|---------|-------------|
| **Rôle** | Apprenant inscrit |
| **Description** | Visualisation du pourcentage d'avancement par chapitre et leçon |
| **Résultat** | Tableau de bord de progression affiché |

---

## 5. Inscription aux cours

### 5.1 Inscription gratuite

| Élément | Description |
|---------|-------------|
| **Rôle** | Apprenant |
| **Description** | Inscription directe à un cours gratuit |
| **Résultat** | Inscription créée avec état "actif" |

### 5.2 Inscription payante

| Élément | Description |
|---------|-------------|
| **Rôle** | Apprenant |
| **Description** | Paiement du cours via le moyen proposés, puis inscription |
| **Résultat** | Paiement validé, inscription créée |

### 5.3 Consultation des inscriptions

| Élément | Description |
|---------|-------------|
| **Rôle** | Apprenant, Administrateur |
| **Description** | Liste des cours auxquels l'utilisateur est inscris |
| **Résultat** | Liste affichée avec état et progression |

### 5.4 Abandon de cours

| Élément | Description |
|---------|-------------|
| **Rôle** | Apprenant |
| **Description** | Demande d'abandon d'un cours inscris |
| **Résultat** | Inscription marquée "abandonné" |

---

## 6. Gestion des sessions et des accès

### 6.1 Connexion

| Élément | Description |
|---------|-------------|
| **Rôle** | Tous les utilisateurs |
| **Description** | Authentification par email et mot de passe |
| **Résultat** | Session créée, accès aux fonctionnalités selon rôle |

### 6.2 Déconnexion

| Élément | Description |
|---------|-------------|
| **Rôle** | Tous les utilisateurs |
| **Description** | Demande de déconnexion explicite |
| **Résultat** | Session fermée, renvoi vers page de connexion |

### 6.3 Gestion des accès

| Élément | Description |
|---------|-------------|
| **Rôle** | Administrateur |
| **Description** | Contrôle des droits par rôle : restriction des routes et fonctionnalités |
| **Résultat** | Accès autorisé ou refusé dynamiques selon le rôle |

### 6.4 Journal d'activité

| Élément | Description |
|---------|-------------|
| **Rôle** | Administrateur |
| **Description** | Consultation de l'historique des actions (connexion, inscription, soumission, modification) |
| **Résultat** | Logs d'activité consultables et filtrables |

### 6.5 Sécurisation des accès

| Élément | Description |
|---------|-------------|
| **Rôle** | Système |
| **Description** | Vérification systématique de l'authentification et des droits avant chaque action |
| **Résultat** | Requête rejetée si non autorisé (401/403) |

---

## Tableau des droits par rôle

| Fonctionnalité | Administrateur | Formateur | Apprenant |
|-----------------|-----------------|-----------|-----------|
| Gestion des utilisateurs | ✓ | - | (propre compte) |
| Consultation des cours | ✓ | ✓ | ✓ |
| Création de cours | ✓ | ✓ | - |
| Téléversement de ressources | ✓ | ✓ | - |
| Évaluation des devoirs | ✓ | ✓ | - |
| Notation des cours | ✓ | - | ✓ |
| Inscription aux cours | ✓ | - | ✓ |
| Gestion des sessions | ✓ | - | (propre session) |
| Journal d'activité | ✓ | - | - |