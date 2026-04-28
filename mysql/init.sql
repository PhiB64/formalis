-- CREATION DES TABLES

CREATE TABLE IF NOT EXISTS utilisateur (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    mot_de_passe VARCHAR(255) NOT NULL,
    role ENUM('apprenant', 'formateur', 'administrateur') NOT NULL DEFAULT 'apprenant',
    date_inscription DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS cours (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(255) NOT NULL,
    description TEXT,
    niveau ENUM('débutant', 'intermédiaire', 'avancé') NOT NULL,
    prix DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    statut ENUM('brouillon', 'publié', 'archivé') NOT NULL DEFAULT 'brouillon',
    date_publication DATETIME,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    formateur_id INT NOT NULL,
    FOREIGN KEY (formateur_id) REFERENCES utilisateur(id) ON DELETE RESTRICT
);


CREATE TABLE IF NOT EXISTS chapitre (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cours_id INT NOT NULL,
    titre VARCHAR(255) NOT NULL,
    description TEXT,
    ordre INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (cours_id) REFERENCES cours(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS lecon (
    id INT AUTO_INCREMENT PRIMARY KEY,
    chapitre_id INT NOT NULL,
    titre VARCHAR(255) NOT NULL,
    contenu TEXT,
    duree_minutes INT,
    ordre INT NOT NULL,
    type ENUM('texte', 'vidéo', 'exercice', 'devoir') NOT NULL DEFAULT 'texte',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (chapitre_id) REFERENCES chapitre(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS categorie (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS tag (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL UNIQUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Table COURS_CATEGORIE (relation many-to-many)
CREATE TABLE IF NOT EXISTS cours_categorie (
    cours_id INT NOT NULL,
    categorie_id INT NOT NULL,
    PRIMARY KEY (cours_id, categorie_id),
    FOREIGN KEY (cours_id) REFERENCES cours(id) ON DELETE CASCADE,
    FOREIGN KEY (categorie_id) REFERENCES categorie(id) ON DELETE CASCADE
);

-- Table COURS_TAG (relation many-to-many)
CREATE TABLE IF NOT EXISTS cours_tag (
    cours_id INT NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (cours_id, tag_id),
    FOREIGN KEY (cours_id) REFERENCES cours(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tag(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS inscription (
    id INT AUTO_INCREMENT PRIMARY KEY,
    utilisateur_id INT NOT NULL,
    cours_id INT NOT NULL,
    date_inscription DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    etat ENUM('actif', 'abandonné', 'terminé') NOT NULL DEFAULT 'actif',
    progression INT NOT NULL DEFAULT 0,
    date_mise_a_jour DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_inscription (utilisateur_id, cours_id),
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(id) ON DELETE CASCADE,
    FOREIGN KEY (cours_id) REFERENCES cours(id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS avis (
    id INT AUTO_INCREMENT PRIMARY KEY,
    utilisateur_id INT NOT NULL,
    cours_id INT NOT NULL,
    note INT NOT NULL CHECK (note BETWEEN 1 AND 5),
    commentaire TEXT,
    date_creation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_avis_utilisateur_cours (utilisateur_id, cours_id),
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(id) ON DELETE CASCADE,
    FOREIGN KEY (cours_id) REFERENCES cours(id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS paiement (
    id INT AUTO_INCREMENT PRIMARY KEY,
    utilisateur_id INT NOT NULL,
    cours_id INT NOT NULL,
    montant DECIMAL(10, 2) NOT NULL,
    moyen_paiement ENUM('carte_bancaire', 'virement', 'paypal') NOT NULL,
    date_paiement DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    statut ENUM('en_attente', 'validé', 'refusé', 'remboursé') NOT NULL DEFAULT 'en_attente',
    reference_transaction VARCHAR(255) UNIQUE,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(id) ON DELETE CASCADE,
    FOREIGN KEY (cours_id) REFERENCES cours(id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS question (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cours_id INT NOT NULL,
    auteur_id INT NOT NULL,
    titre VARCHAR(255) NOT NULL,
    contenu TEXT NOT NULL,
    date_creation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    est_resolue BOOLEAN NOT NULL DEFAULT FALSE,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (cours_id) REFERENCES cours(id) ON DELETE CASCADE,
    FOREIGN KEY (auteur_id) REFERENCES utilisateur(id) ON DELETE RESTRICT
);


CREATE TABLE IF NOT EXISTS reponse (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question_id INT NOT NULL,
    auteur_id INT NOT NULL,
    contenu TEXT NOT NULL,
    date_creation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    est_solution BOOLEAN NOT NULL DEFAULT FALSE,
    parent_reponse_id INT,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (question_id) REFERENCES question(id) ON DELETE CASCADE,
    FOREIGN KEY (auteur_id) REFERENCES utilisateur(id) ON DELETE RESTRICT,
    FOREIGN KEY (parent_reponse_id) REFERENCES reponse(id) ON DELETE SET NULL
);


CREATE TABLE IF NOT EXISTS activite_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    utilisateur_id INT,
    type ENUM('connexion', 'déconnexion', 'consultation_cours', 'inscription', 'soumission_devoir', 'notation', 'modification_profil') NOT NULL,
    description TEXT,
    entite_type VARCHAR(50),
    entite_id INT,
    adresse_ip VARCHAR(45),
    date_creation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(id) ON DELETE SET NULL
);






-- DONNÉES DE TEST

-- Utilisateurs (mot de passe: password123 pour tous)
INSERT INTO utilisateur (nom, prenom, email, mot_de_passe, role) VALUES
('Dupont', 'Jean', 'jean.dupont@formalis.fr', '$2a$10$xGJ9Q7K5P5xH5xH5xH5xHO5xH5xH5xH5xH5xH5xH5xH5xH5xH', 'administrateur'),
('Martin', 'Sophie', 'sophie.martin@formalis.fr', '$2a$10$xGJ9Q7K5P5xH5xH5xH5xHO5xH5xH5xH5xH5xH5xH5xH5xH', 'formateur'),
('Bernard', 'Lucas', 'lucas.bernard@formalis.fr', '$2a$10$xGJ9Q7K5P5xH5xH5xH5xHO5xH5xH5xH5xH5xH5xH5xH5xH', 'formateur'),
('Thomas', 'Emma', 'emma.thomas@formalis.fr', '$2a$10$xGJ9Q7K5P5xH5xH5xH5xHO5xH5xH5xH5xH5xH5xH5xH', 'apprenant'),
('Petit', 'Louis', 'louis.petit@formalis.fr', '$2a$10$xGJ9Q7K5P5xH5xH5xH5xHO5xH5xH5xH5xH5xH5xH5xH', 'apprenant');


INSERT INTO categorie (nom, description) VALUES
('Développement web', 'Cours de développement web et internet'),
('Base de données', 'Cours de gestion et conception de bases de données'),
('DevOps', 'Cours sur les pratiques et outils DevOps'),
('Programmation', 'Cours de programmation dans divers langages');


INSERT INTO tag (nom) VALUES
('javascript'),
('python'),
('mysql'),
('docker'),
('linux'),
('api'),
('rest'),
('sql');


INSERT INTO cours (titre, description, niveau, prix, statut, date_publication, formateur_id) VALUES
('Introduction au JavaScript', 'Apprenez les bases du langage JavaScript pour le web', 'débutant', 0.00, 'publié', '2026-01-15 10:00:00', 2),
('MySQL - Gestion de base de données', 'Maîtrisez MySQL de A à Z', 'intermédiaire', 49.99, 'publié', '2026-02-01 10:00:00', 2),
('Docker pour les développeurs', 'Conteneurisez vos applications', 'intermédiaire', 79.99, 'publié', '2026-03-01 10:00:00', 3);

-- Relations cours_categorie
INSERT INTO cours_categorie (cours_id, categorie_id) VALUES
(1, 1), (1, 4),
(2, 2),
(3, 3);

-- Relations cours_tag
INSERT INTO cours_tag (cours_id, tag_id) VALUES
(1, 1), (1, 6), (1, 7),
(2, 3), (2, 8),
(3, 4), (3, 5);


INSERT INTO chapitre (cours_id, titre, description, ordre) VALUES
(1, 'Les bases de JavaScript', 'Introduction aux fondamentaux', 1),
(1, 'Fonctions et objets', 'Apprenez à organiser votre code', 2),
(1, 'Manipulation du DOM', 'Interagissez avec la page web', 3),
(2, 'Installation et configuration', 'Premiers pas avec MySQL', 1),
(2, 'Langage SQL', 'Apprenez à écrire des requêtes', 2),
(3, 'Introduction à Docker', 'Les concepts de base', 1),
(3, 'Docker Compose', 'Orchestrer vos conteneurs', 2);


INSERT INTO lecon (chapitre_id, titre, contenu, duree_minutes, ordre, type) VALUES
(1, 'Variables et types', 'Les variables en JavaScript: let, const, var...', 15, 1, 'texte'),
(1, 'Opérateurs', 'Les opérateurs arithmétiques et logiques', 10, 2, 'texte'),
(1, 'Vidéo: Premier script', 'Vidéo explicative', 10, 3, 'vidéo'),
(2, 'Fonctions', 'Déclarer et utiliser des fonctions', 20, 1, 'texte'),
(2, 'Objets', 'Créer et manipuler des objets', 25, 2, 'texte'),
(3, 'Sélectionner un élément', 'document.querySelector', 15, 1, 'texte'),
(3, 'Modifier le DOM', 'Créer et modifier des éléments', 20, 2, 'texte'),
(4, 'Installation de MySQL', 'Guide d''installation', 15, 1, 'texte'),
(4, ' Création d''une base', 'CREATE DATABASE', 10, 2, 'texte'),
(5, 'SELECT', 'Interroger une table', 20, 1, 'texte'),
(5, 'INSERT', 'Insérer des données', 15, 2, 'texte'),
(5, 'Exercice SQL', 'Pratiquez vos connaissances', 30, 3, 'exercice'),
(6, 'Images et conteneurs', 'Comprendre Docker', 15, 1, 'texte'),
(6, 'Commandes de base', 'docker run, ps, logs...', 20, 2, 'texte'),
(7, 'docker-compose.yml', 'Orchestrer plusieurs services', 25, 1, 'texte'),
(7, 'TP Docker', 'Créez votre premier docker-compose', 45, 2, 'exercice');


INSERT INTO inscription (utilisateur_id, cours_id, etat, progression) VALUES
(4, 1, 'actif', 100),
(4, 2, 'actif', 60),
(5, 1, 'actif', 80),
(5, 3, 'actif', 30);


INSERT INTO avis (utilisateur_id, cours_id, note, commentaire) VALUES
(4, 1, 5, 'Excellent cours pour débutants, très bien illustré!'),
(5, 1, 4, 'Bon cours, mais manque d''exercices pratiques.');


INSERT INTO paiement (utilisateur_id, cours_id, montant, moyen_paiement, statut, reference_transaction) VALUES
(4, 2, 49.99, 'carte_bancaire', 'validé', 'TXN-2026-001'),
(5, 3, 79.99, 'carte_bancaire', 'validé', 'TXN-2026-002');


INSERT INTO question (cours_id, auteur_id, titre, contenu, est_resolue) VALUES
(1, 4, 'Différence entre let et const?', 'Quand utiliser let plutôt que const?', TRUE),
(2, 5, 'Comment faire une jointure?', 'Je ne comprends pas les LEFT JOIN', FALSE);


INSERT INTO reponse (question_id, auteur_id, contenu, est_solution) VALUES
(1, 2, 'Utilisez const par défaut, et let seulement si la variable doit être modifiée.', TRUE),
(2, 2, 'Une LEFT JOIN retourne toutes les lignes de la table de gauche...', FALSE);


INSERT INTO activite_log (utilisateur_id, type, description, entite_type, entite_id, adresse_ip) VALUES
(4, 'connexion', 'Connexion à la plateforme', 'utilisateur', 4, '192.168.1.100'),
(4, 'consultation_cours', 'Consultation du cours JavaScript', 'cours', 1, '192.168.1.100'),
(4, 'inscription', 'Inscription au cours MySQL', 'cours', 2, '192.168.1.100'),
(5, 'notation', 'Dépôt d''un avis', 'cours', 1, '192.168.1.101');