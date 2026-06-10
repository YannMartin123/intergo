-- 1. Table : departement
CREATE TABLE departement (
    id BIGINT AUTO_INCREMENT,
    nom VARCHAR(100) NOT NULL,
    responsable VARCHAR(100),
    budget_masse_salariale DECIMAL(14,2),
    CONSTRAINT pk_departement PRIMARY KEY (id),
    CONSTRAINT uq_departement_nom UNIQUE (nom)
) ENGINE=InnoDB;

-- 2. Table : employe
CREATE TABLE employe (
    id BIGINT AUTO_INCREMENT,
    matricule VARCHAR(20) NOT NULL,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    poste VARCHAR(100) NOT NULL,
    departement_id BIGINT NOT NULL,
    date_embauche DATE NOT NULL,
    salaire_base DECIMAL(10,2) NULL, -- Mis en NULL car l'historique/vrai salaire est dans la table contrat_employe
    type_contrat ENUM('CDI', 'CDD', 'STAGE', 'CONSULTANT') NULL, -- Harmonisé avec contrat_employe
    telephone VARCHAR(20),
    email VARCHAR(150) NOT NULL,
    photo_filename VARCHAR(200),
    solde_conges_jours INT DEFAULT 0,
    CONSTRAINT pk_employe PRIMARY KEY (id),
    CONSTRAINT uq_employe_matricule UNIQUE (matricule),
    CONSTRAINT uq_employe_email UNIQUE (email),
    CONSTRAINT fk_employe_departement FOREIGN KEY (departement_id) REFERENCES departement(id)
) ENGINE=InnoDB;

-- 3. Table : contrat_employe
CREATE TABLE contrat_employe (
    id BIGINT AUTO_INCREMENT,
    employe_id BIGINT NOT NULL,
    type_contrat ENUM('CDI', 'CDD', 'STAGE', 'CONSULTANT') NOT NULL, -- Ajout de 'CONSULTANT' pour cohérence
    date_debut DATE NOT NULL,
    date_fin DATE NULL, -- Peut être NULL (ex: pour un CDI)
    salaire DECIMAL(10,2) NOT NULL,
    avantages VARCHAR(300),
    CONSTRAINT pk_contrat PRIMARY KEY (id),
    CONSTRAINT fk_contrat_employe FOREIGN KEY (employe_id) REFERENCES employe(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 4. Table : conge (Demande de Congé)
CREATE TABLE conge (
    id BIGINT AUTO_INCREMENT,
    employe_id BIGINT NOT NULL,
    type_conge ENUM('ANNUEL', 'MALADIE', 'MATERNITE', 'PATERNITE', 'EXCEPTIONNEL'),
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    nb_jours INT NOT NULL, -- Calculé automatiquement par l'application
    motif VARCHAR(300),
    statut ENUM('DEMANDE', 'APPROUVE', 'REFUSE') DEFAULT 'DEMANDE', -- Ajout d'une valeur par défaut logique
    approuve_par VARCHAR(100),
    CONSTRAINT pk_conge PRIMARY KEY (id),
    CONSTRAINT fk_conge_employe FOREIGN KEY (employe_id) REFERENCES employe(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 5. Table : fiche_paie
CREATE TABLE fiche_paie (
    id BIGINT AUTO_INCREMENT,
    employe_id BIGINT NOT NULL,
    mois VARCHAR(7) NOT NULL, -- Format AAAA-MM
    salaire_base DECIMAL(10,2) NOT NULL,
    heures_sup DECIMAL(6,2) DEFAULT 0,
    montant_heures_sup DECIMAL(10,2) DEFAULT 0,
    primes DECIMAL(10,2) DEFAULT 0,
    retenues DECIMAL(10,2) DEFAULT 0,
    salaire_brut DECIMAL(10,2) NOT NULL,
    salaire_net DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_fiche_paie PRIMARY KEY (id),
    CONSTRAINT fk_fiche_paie_employe FOREIGN KEY (employe_id) REFERENCES employe(id) ON DELETE CASCADE,
    CONSTRAINT uq_employe_mois UNIQUE (employe_id, mois)
) ENGINE=InnoDB;

-- 6. Création de la table des rôles
CREATE TABLE role (
    id BIGINT AUTO_INCREMENT,
    nom VARCHAR(50) NOT NULL,
    CONSTRAINT pk_role PRIMARY KEY (id),
    CONSTRAINT uq_role_nom UNIQUE (nom)
) ENGINE=InnoDB;

-- 7. Création de la table des utilisateurs
CREATE TABLE utilisateur (
    id BIGINT AUTO_INCREMENT,
    email VARCHAR(150) NOT NULL,
    mot_de_passe VARCHAR(255) NOT NULL, -- Destiné à recevoir du BCrypt/Argon2 côté Java
    est_actif BOOLEAN DEFAULT TRUE,
    employe_id BIGINT UNIQUE NULL,
    CONSTRAINT pk_utilisateur PRIMARY KEY (id),
    CONSTRAINT uq_utilisateur_email UNIQUE (email),
    CONSTRAINT fk_utilisateur_employe FOREIGN KEY (employe_id) REFERENCES employe(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 8. Table de jointure Utilisateur <-> Role
CREATE TABLE utilisateur_roles (
    utilisateur_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    CONSTRAINT pk_utilisateur_roles PRIMARY KEY (utilisateur_id, role_id),
    CONSTRAINT fk_ur_utilisateur FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(id) ON DELETE CASCADE,
    CONSTRAINT fk_ur_role FOREIGN KEY (role_id) REFERENCES role(id) ON DELETE CASCADE
) ENGINE=InnoDB;


-- =========================================================================
-- INSERTIONS DE DONNÉES (Sécurisées sans ID en dur pour les liaisons)
-- =========================================================================

-- Insertion des rôles principaux
INSERT INTO role (nom) VALUES ('ADMIN'), ('RH'), ('MANAGER'), ('EMPLOYE');

-- Insertion d'un utilisateur administrateur de test
INSERT INTO utilisateur (email, mot_de_passe, est_actif, employe_id) 
VALUES ('admin@entreprise.com', '$2a$12$t0WOhaYkiPVIwSfydKdfZeO5R8loOD6ZEj/qhSyF8dZ23BYLymAtm', TRUE, NULL);

-- Association dynamique de l'utilisateur au rôle ADMIN (évite les erreurs d'ID auto-incrémenté)
INSERT INTO utilisateur_roles (utilisateur_id, role_id) 
VALUES (
    (SELECT id FROM utilisateur WHERE email = 'admin@entreprise.com'),
    (SELECT id FROM role WHERE nom = 'ADMIN')
);