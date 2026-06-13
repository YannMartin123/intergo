-- Drop existing tables in reverse dependency order to avoid foreign key conflicts
DROP TABLE IF EXISTS chat_message;
DROP TABLE IF EXISTS notification;
DROP TABLE IF EXISTS utilisateur_roles;
DROP TABLE IF EXISTS utilisateur;
DROP TABLE IF EXISTS role;
DROP TABLE IF EXISTS fiche_paie;
DROP TABLE IF EXISTS conge;
DROP TABLE IF EXISTS contrat_employe;
DROP TABLE IF EXISTS employe;
DROP TABLE IF EXISTS departement;

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


-- 9. Table : notification
CREATE TABLE notification (
    id BIGINT AUTO_INCREMENT,
    expediteur VARCHAR(150) NOT NULL,
    destinataire VARCHAR(150) NOT NULL,
    sujet VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    date_envoi DATETIME NOT NULL,
    lu BOOLEAN DEFAULT FALSE,
    CONSTRAINT pk_notification PRIMARY KEY (id)
) ENGINE=InnoDB;

-- 10. Table : chat_message
CREATE TABLE chat_message (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    sender_email VARCHAR(150) NOT NULL,
    receiver_email VARCHAR(150) NOT NULL,
    message TEXT NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    file_name VARCHAR(255) NULL,
    file_type VARCHAR(100) NULL,
    file_url VARCHAR(500) NULL
) ENGINE=InnoDB;


-- =========================================================================
-- INSERTIONS DE DONNÉES (20+ lignes par table)
-- =========================================================================

-- 1. Insertion des rôles principaux
INSERT INTO role (nom) VALUES ('ADMIN'), ('RH'), ('MANAGER'), ('EMPLOYE');

-- 2. Insertion de 20 Départements
INSERT INTO departement (nom, responsable, budget_masse_salariale) VALUES
('Direction Générale', 'Jean-Pierre Dubois', 250000.00),
('Ressources Humaines', 'Marie Laurent', 80000.00),
('Finance', 'Sophie Martin', 120000.00),
('Recherche & Développement', 'Thomas Bernard', 300000.00),
('Informatique / IT', 'Lucas Petit', 200000.00),
('Marketing', 'Emma Richard', 90000.00),
('Ventes', 'Hugo Durand', 150000.00),
('Support Client', 'Chloé Lefebvre', 65000.00),
('Logistique', 'Arthur Moreau', 75000.00),
('Achats', 'Nathan Simon', 55000.00),
('Communication', 'Léa Michel', 45000.00),
('Production', 'Enzo Garcia', 85000.00),
('Contrôle Qualité', 'Camille Roux', 50000.00),
('Sécurité', 'Louis David', 40000.00),
('Juridique', 'Manon Bertrand', 60000.00),
('Design & UX', 'Clara Vincent', 95000.00),
('DevOps', 'Julien Francois', 140000.00),
('Data & Analytics', 'Antoine Girard', 160000.00),
('Relations Publiques', 'Zoe Lemaire', 48000.00),
('Systèmes & Réseaux', 'Maxime Fontaine', 110000.00);

-- 3. Insertion de 20 Employés
INSERT INTO employe (matricule, nom, prenom, poste, departement_id, date_embauche, salaire_base, type_contrat, telephone, email, photo_filename, solde_conges_jours) VALUES
('EMP001', 'Dubois', 'Jean-Pierre', 'Directeur Général', 1, '2020-01-15', 8500.00, 'CDI', '0601020304', 'jp.dubois@entreprise.com', NULL, 30),
('EMP002', 'Laurent', 'Marie', 'Directrice RH', 2, '2020-05-10', 4500.00, 'CDI', '0611121314', 'm.laurent@entreprise.com', NULL, 28),
('EMP003', 'Martin', 'Sophie', 'Directrice Financière', 3, '2021-02-01', 5200.00, 'CDI', '0621222324', 's.martin@entreprise.com', NULL, 25),
('EMP004', 'Bernard', 'Thomas', 'Directeur R&D', 4, '2021-03-20', 5800.00, 'CDI', '0631323334', 't.bernard@entreprise.com', NULL, 26),
('EMP005', 'Petit', 'Lucas', 'Responsable IT', 5, '2022-01-10', 4200.00, 'CDI', '0641424344', 'l.petit@entreprise.com', NULL, 22),
('EMP006', 'Richard', 'Emma', 'Responsable Marketing', 6, '2022-06-15', 3800.00, 'CDI', '0651525354', 'e.richard@entreprise.com', NULL, 24),
('EMP007', 'Durand', 'Hugo', 'Responsable des Ventes', 7, '2021-09-01', 4000.00, 'CDI', '0661626364', 'h.durand@entreprise.com', NULL, 20),
('EMP008', 'Lefebvre', 'Chloé', 'Support Leader', 8, '2023-01-05', 2800.00, 'CDI', '0671727374', 'c.lefebvre@entreprise.com', NULL, 25),
('EMP009', 'Moreau', 'Arthur', 'Chef Logistique', 9, '2022-11-20', 3200.00, 'CDI', '0681828384', 'a.moreau@entreprise.com', NULL, 15),
('EMP010', 'Simon', 'Nathan', 'Acheteur Senior', 10, '2023-03-15', 3400.00, 'CDI', '0691929394', 'n.simon@entreprise.com', NULL, 18),
('EMP011', 'Michel', 'Léa', 'Chargée de Com', 11, '2023-05-10', 2700.00, 'CDD', '0602030405', 'l.michel@entreprise.com', NULL, 12),
('EMP012', 'Garcia', 'Enzo', 'Chef de Production', 12, '2022-08-01', 3500.00, 'CDI', '0612131415', 'e.garcia@entreprise.com', NULL, 20),
('EMP013', 'Roux', 'Camille', 'Ingénieur Qualité', 13, '2023-06-01', 3100.00, 'CDI', '0622232425', 'c.roux@entreprise.com', NULL, 24),
('EMP014', 'David', 'Louis', 'Responsable Sécurité', 14, '2021-12-01', 3300.00, 'CDI', '0632333435', 'l.david@entreprise.com', NULL, 26),
('EMP015', 'Bertrand', 'Manon', 'Juriste Corporate', 15, '2023-02-15', 3600.00, 'CDI', '0642434445', 'm.bertrand@entreprise.com', NULL, 25),
('EMP016', 'Vincent', 'Clara', 'Lead UI/UX', 16, '2023-09-01', 3900.00, 'CDI', '0652535455', 'c.vincent@entreprise.com', NULL, 30),
('EMP017', 'Francois', 'Julien', 'Ingénieur DevOps', 17, '2022-04-18', 4100.00, 'CDI', '0662636465', 'j.francois@entreprise.com', NULL, 22),
('EMP018', 'Girard', 'Antoine', 'Data Scientist', 18, '2022-10-01', 4300.00, 'CDI', '0672737475', 'a.girard@entreprise.com', NULL, 25),
('EMP019', 'Lemaire', 'Zoe', 'Attachée de Presse', 19, '2024-01-10', 2500.00, 'STAGE', '0682838485', 'z.lemaire@entreprise.com', NULL, 5),
('EMP020', 'Fontaine', 'Maxime', 'Administrateur Réseau', 20, '2023-11-15', 3000.00, 'CDD', '0692939495', 'm.fontaine@entreprise.com', NULL, 14);

-- 4. Insertion de 20 Contrats
INSERT INTO contrat_employe (employe_id, type_contrat, date_debut, date_fin, salaire, avantages) VALUES
(1, 'CDI', '2020-01-15', NULL, 8500.00, 'Voiture de fonction, Logement de fonction, Actions entreprise'),
(2, 'CDI', '2020-05-10', NULL, 4500.00, 'Tickets Restaurant, Assurance santé premium'),
(3, 'CDI', '2021-02-01', NULL, 5200.00, 'Tickets Restaurant, Assurance santé premium'),
(4, 'CDI', '2021-03-20', NULL, 5800.00, 'Tickets Restaurant, Voiture de fonction'),
(5, 'CDI', '2022-01-10', NULL, 4200.00, 'Tickets Restaurant, Ordinateur portable pro'),
(6, 'CDI', '2022-06-15', NULL, 3800.00, 'Tickets Restaurant, Transports pris en charge à 50%'),
(7, 'CDI', '2021-09-01', NULL, 4000.00, 'Tickets Restaurant, Téléphone de fonction, Bonus ventes'),
(8, 'CDI', '2023-01-05', NULL, 2800.00, 'Tickets Restaurant'),
(9, 'CDI', '2022-11-20', NULL, 3200.00, 'Tickets Restaurant'),
(10, 'CDI', '2023-03-15', NULL, 3400.00, 'Tickets Restaurant'),
(11, 'CDD', '2023-05-10', '2024-05-09', 2700.00, 'Tickets Restaurant'),
(12, 'CDI', '2022-08-01', NULL, 3500.00, 'Tickets Restaurant, Prime d\'usine'),
(13, 'CDI', '2023-06-01', NULL, 3100.00, 'Tickets Restaurant'),
(14, 'CDI', '2021-12-01', NULL, 3300.00, 'Tickets Restaurant'),
(15, 'CDI', '2023-02-15', NULL, 3600.00, 'Tickets Restaurant'),
(16, 'CDI', '2023-09-01', NULL, 3900.00, 'Tickets Restaurant, Télétravail 2 jours/semaine'),
(17, 'CDI', '2022-04-18', NULL, 4100.00, 'Tickets Restaurant, Ordinateur portable pro'),
(18, 'CDI', '2022-10-01', NULL, 4300.00, 'Tickets Restaurant, Prime d\'innovation'),
(19, 'STAGE', '2024-01-10', '2024-07-09', 800.00, 'Remboursement navigo à 100%'),
(20, 'CDD', '2023-11-15', '2024-11-14', 3000.00, 'Tickets Restaurant');

-- 5. Insertion de 20 Congés
INSERT INTO conge (employe_id, type_conge, date_debut, date_fin, nb_jours, motif, statut, approuve_par) VALUES
(2, 'ANNUEL', '2024-08-01', '2024-08-15', 15, 'Vacances d\'été', 'APPROUVE', 'jp.dubois@entreprise.com'),
(3, 'ANNUEL', '2024-12-20', '2024-12-31', 11, 'Fêtes de fin d\'année', 'APPROUVE', 'jp.dubois@entreprise.com'),
(5, 'MALADIE', '2024-03-04', '2024-03-08', 5, 'Grippe saisonnière', 'APPROUVE', 'm.laurent@entreprise.com'),
(6, 'EXCEPTIONNEL', '2024-04-10', '2024-04-12', 3, 'Mariage', 'APPROUVE', 'm.laurent@entreprise.com'),
(8, 'ANNUEL', '2024-07-15', '2024-07-22', 8, 'Voyage', 'APPROUVE', 'm.laurent@entreprise.com'),
(11, 'ANNUEL', '2024-05-01', '2024-05-10', 10, 'Repos', 'APPROUVE', 'm.laurent@entreprise.com'),
(15, 'MATERNITE', '2024-09-01', '2024-12-31', 122, 'Congé maternité légal', 'APPROUVE', 'm.laurent@entreprise.com'),
(19, 'ANNUEL', '2024-02-15', '2024-02-16', 2, 'Déplacement personnel', 'APPROUVE', 'm.laurent@entreprise.com'),
(4, 'ANNUEL', '2026-06-15', '2026-06-20', 6, 'Vacances', 'DEMANDE', NULL),
(7, 'ANNUEL', '2026-07-01', '2026-07-10', 10, 'Repos estival', 'DEMANDE', NULL),
(9, 'ANNUEL', '2026-06-22', '2026-06-25', 4, 'Déménagement', 'DEMANDE', NULL),
(10, 'ANNUEL', '2026-08-05', '2026-08-15', 11, 'Vacances d\'été', 'DEMANDE', NULL),
(12, 'MALADIE', '2026-06-12', '2026-06-14', 3, 'Rendez-vous médical', 'DEMANDE', NULL),
(13, 'ANNUEL', '2026-07-12', '2026-07-19', 8, 'Vacances', 'DEMANDE', NULL),
(14, 'EXCEPTIONNEL', '2026-06-18', '2026-06-19', 2, 'Événement familial', 'DEMANDE', NULL),
(16, 'ANNUEL', '2026-06-30', '2026-07-05', 6, 'Repos', 'DEMANDE', NULL),
(17, 'ANNUEL', '2026-07-20', '2026-07-25', 6, 'Voyage', 'DEMANDE', NULL),
(18, 'ANNUEL', '2026-08-10', '2026-08-20', 11, 'Vacances', 'DEMANDE', NULL),
(20, 'ANNUEL', '2026-06-25', '2026-06-27', 3, 'Visite familial', 'DEMANDE', NULL),
(5, 'EXCEPTIONNEL', '2026-07-02', '2026-07-03', 2, 'Déménagement', 'REFUSE', 'm.laurent@entreprise.com');

-- 6. Insertion de 20 Fiches de Paie
INSERT INTO fiche_paie (employe_id, mois, salaire_base, heures_sup, montant_heures_sup, primes, retenues, salaire_brut, salaire_net) VALUES
(1, '2026-05', 8500.00, 0.00, 0.00, 500.00, 1500.00, 9000.00, 7500.00),
(2, '2026-05', 4500.00, 4.00, 120.00, 200.00, 800.00, 4820.00, 4020.00),
(3, '2026-05', 5200.00, 0.00, 0.00, 300.00, 900.00, 5500.00, 4600.00),
(4, '2026-05', 5800.00, 0.00, 0.00, 400.00, 1000.00, 6200.00, 5200.00),
(5, '2026-05', 4200.00, 10.00, 300.00, 150.00, 750.00, 4650.00, 3900.00),
(6, '2026-05', 3800.00, 8.00, 200.00, 100.00, 650.00, 4100.00, 3450.00),
(7, '2026-05', 4000.00, 12.00, 360.00, 600.00, 800.00, 4960.00, 4160.00),
(8, '2026-05', 2800.00, 5.00, 100.00, 50.00, 450.00, 2950.00, 2500.00),
(9, '2026-05', 3200.00, 0.00, 0.00, 100.00, 550.00, 3300.00, 2750.00),
(10, '2026-05', 3400.00, 6.00, 150.00, 120.00, 600.00, 3670.00, 3070.00),
(11, '2026-05', 2700.00, 0.00, 0.00, 0.00, 450.00, 2700.00, 2250.00),
(12, '2026-05', 3500.00, 15.00, 375.00, 250.00, 650.00, 4125.00, 3475.00),
(13, '2026-05', 3100.00, 4.00, 90.00, 100.00, 500.00, 3290.00, 2790.00),
(14, '2026-05', 3300.00, 0.00, 0.00, 150.00, 550.00, 3450.00, 2900.00),
(15, '2026-05', 3600.00, 0.00, 0.00, 200.00, 600.00, 3800.00, 3200.00),
(16, '2026-05', 3900.00, 5.00, 130.00, 300.00, 700.00, 4330.00, 3630.00),
(17, '2026-05', 4100.00, 8.00, 240.00, 200.00, 750.00, 4540.00, 3790.00),
(18, '2026-05', 4300.00, 12.00, 360.00, 500.00, 800.00, 5160.00, 4360.00),
(19, '2026-05', 800.00, 0.00, 0.00, 50.00, 50.00, 850.00, 800.00),
(20, '2026-05', 3000.00, 6.00, 130.00, 100.00, 500.00, 3230.00, 2730.00);

-- 7. Insertion de 20 Utilisateurs de test (avec mots de passe BCrypt valides basés sur le sel $2a$)
INSERT INTO utilisateur (email, mot_de_passe, est_actif, employe_id) VALUES
('admin@entreprise.com', '$2a$12$t0WOhaYkiPVIwSfydKdfZeO5R8loOD6ZEj/qhSyF8dZ23BYLymAtm', TRUE, NULL),
('jp.dubois@entreprise.com', '$2a$12$t0WOhaYkiPVIwSfydKdfZeO5R8loOD6ZEj/qhSyF8dZ23BYLymAtm', TRUE, 1),
('m.laurent@entreprise.com', '$2a$12$t0WOhaYkiPVIwSfydKdfZeO5R8loOD6ZEj/qhSyF8dZ23BYLymAtm', TRUE, 2),
('s.martin@entreprise.com', '$2a$12$t0WOhaYkiPVIwSfydKdfZeO5R8loOD6ZEj/qhSyF8dZ23BYLymAtm', TRUE, 3),
('t.bernard@entreprise.com', '$2a$12$t0WOhaYkiPVIwSfydKdfZeO5R8loOD6ZEj/qhSyF8dZ23BYLymAtm', TRUE, 4),
('l.petit@entreprise.com', '$2a$12$t0WOhaYkiPVIwSfydKdfZeO5R8loOD6ZEj/qhSyF8dZ23BYLymAtm', TRUE, 5),
('e.richard@entreprise.com', '$2a$12$t0WOhaYkiPVIwSfydKdfZeO5R8loOD6ZEj/qhSyF8dZ23BYLymAtm', TRUE, 6),
('h.durand@entreprise.com', '$2a$12$t0WOhaYkiPVIwSfydKdfZeO5R8loOD6ZEj/qhSyF8dZ23BYLymAtm', TRUE, 7),
('c.lefebvre@entreprise.com', '$2a$12$t0WOhaYkiPVIwSfydKdfZeO5R8loOD6ZEj/qhSyF8dZ23BYLymAtm', TRUE, 8),
('a.moreau@entreprise.com', '$2a$12$t0WOhaYkiPVIwSfydKdfZeO5R8loOD6ZEj/qhSyF8dZ23BYLymAtm', TRUE, 9),
('n.simon@entreprise.com', '$2a$12$t0WOhaYkiPVIwSfydKdfZeO5R8loOD6ZEj/qhSyF8dZ23BYLymAtm', TRUE, 10),
('l.michel@entreprise.com', '$2a$12$t0WOhaYkiPVIwSfydKdfZeO5R8loOD6ZEj/qhSyF8dZ23BYLymAtm', TRUE, 11),
('e.garcia@entreprise.com', '$2a$12$t0WOhaYkiPVIwSfydKdfZeO5R8loOD6ZEj/qhSyF8dZ23BYLymAtm', TRUE, 12),
('c.roux@entreprise.com', '$2a$12$t0WOhaYkiPVIwSfydKdfZeO5R8loOD6ZEj/qhSyF8dZ23BYLymAtm', TRUE, 13),
('l.david@entreprise.com', '$2a$12$t0WOhaYkiPVIwSfydKdfZeO5R8loOD6ZEj/qhSyF8dZ23BYLymAtm', TRUE, 14),
('m.bertrand@entreprise.com', '$2a$12$t0WOhaYkiPVIwSfydKdfZeO5R8loOD6ZEj/qhSyF8dZ23BYLymAtm', TRUE, 15),
('c.vincent@entreprise.com', '$2a$12$t0WOhaYkiPVIwSfydKdfZeO5R8loOD6ZEj/qhSyF8dZ23BYLymAtm', TRUE, 16),
('j.francois@entreprise.com', '$2a$12$t0WOhaYkiPVIwSfydKdfZeO5R8loOD6ZEj/qhSyF8dZ23BYLymAtm', TRUE, 17),
('a.girard@entreprise.com', '$2a$12$t0WOhaYkiPVIwSfydKdfZeO5R8loOD6ZEj/qhSyF8dZ23BYLymAtm', TRUE, 18),
('z.lemaire@entreprise.com', '$2a$12$t0WOhaYkiPVIwSfydKdfZeO5R8loOD6ZEj/qhSyF8dZ23BYLymAtm', TRUE, 19),
('m.fontaine@entreprise.com', '$2a$12$t0WOhaYkiPVIwSfydKdfZeO5R8loOD6ZEj/qhSyF8dZ23BYLymAtm', TRUE, 20);

-- 8. Association des Rôles
-- Admin
INSERT INTO utilisateur_roles (utilisateur_id, role_id) VALUES
(1, (SELECT id FROM role WHERE nom = 'ADMIN')),
(2, (SELECT id FROM role WHERE nom = 'MANAGER')),
(3, (SELECT id FROM role WHERE nom = 'RH')),
(4, (SELECT id FROM role WHERE nom = 'MANAGER')),
(5, (SELECT id FROM role WHERE nom = 'MANAGER')),
(6, (SELECT id FROM role WHERE nom = 'MANAGER')),
(7, (SELECT id FROM role WHERE nom = 'EMPLOYE')),
(8, (SELECT id FROM role WHERE nom = 'EMPLOYE')),
(9, (SELECT id FROM role WHERE nom = 'EMPLOYE')),
(10, (SELECT id FROM role WHERE nom = 'EMPLOYE')),
(11, (SELECT id FROM role WHERE nom = 'EMPLOYE')),
(12, (SELECT id FROM role WHERE nom = 'EMPLOYE')),
(13, (SELECT id FROM role WHERE nom = 'EMPLOYE')),
(14, (SELECT id FROM role WHERE nom = 'EMPLOYE')),
(15, (SELECT id FROM role WHERE nom = 'EMPLOYE')),
(16, (SELECT id FROM role WHERE nom = 'EMPLOYE')),
(17, (SELECT id FROM role WHERE nom = 'EMPLOYE')),
(18, (SELECT id FROM role WHERE nom = 'EMPLOYE')),
(19, (SELECT id FROM role WHERE nom = 'EMPLOYE')),
(20, (SELECT id FROM role WHERE nom = 'EMPLOYE')),
(21, (SELECT id FROM role WHERE nom = 'EMPLOYE'));

-- 9. Insertion de 20 Notifications
INSERT INTO notification (expediteur, destinataire, sujet, message, date_envoi, lu) VALUES
('admin@entreprise.com', 'm.laurent@entreprise.com', 'Nouveau recrutement', 'Veuillez préparer les documents d\'accueil pour le nouveau collaborateur.', '2026-06-01 09:00:00', TRUE),
('m.laurent@entreprise.com', 'admin@entreprise.com', 'Rapport mensuel RH', 'Le rapport sur les effectifs de mai 2026 est disponible dans le dossier partagé.', '2026-06-01 14:30:00', TRUE),
('s.martin@entreprise.com', 'admin@entreprise.com', 'Validation budget Q3', 'J\'ai mis à jour les prévisions budgétaires de la masse salariale pour le troisième trimestre.', '2026-06-02 10:15:00', FALSE),
('admin@entreprise.com', 's.martin@entreprise.com', 'Re: Validation budget Q3', 'Merci Sophie, je regarde cela cet après-midi.', '2026-06-02 11:00:00', TRUE),
('jp.dubois@entreprise.com', 'm.laurent@entreprise.com', 'Validation congé annuel', 'Pouvez-vous valider le solde restant de congé pour Lucas Petit ?', '2026-06-03 08:45:00', TRUE),
('m.laurent@entreprise.com', 'jp.dubois@entreprise.com', 'Re: Validation congé annuel', 'C\'est fait, son solde de congés a été mis à jour.', '2026-06-03 09:30:00', TRUE),
('l.petit@entreprise.com', 'admin@entreprise.com', 'Achat de serveurs R&D', 'La demande de devis pour les nouveaux serveurs a été envoyée au service achats.', '2026-06-04 16:20:00', FALSE),
('admin@entreprise.com', 'l.petit@entreprise.com', 'Re: Achat de serveurs R&D', 'Reçu. Tiens-moi informé dès que tu as le retour de Nathan.', '2026-06-04 17:00:00', FALSE),
('n.simon@entreprise.com', 'l.petit@entreprise.com', 'Devis serveurs R&D disponible', 'Le devis du fournisseur IT a été reçu et validé par mon équipe. A vous de jouer.', '2026-06-05 11:10:00', FALSE),
('admin@entreprise.com', 'jp.dubois@entreprise.com', 'Réunion stratégique', 'N\'oubliez pas la réunion du comité de direction demain à 10h en salle de conférence.', '2026-06-05 15:00:00', TRUE),
('jp.dubois@entreprise.com', 'admin@entreprise.com', 'Re: Réunion stratégique', 'Entendu, je serai présent avec mes slides.', '2026-06-05 15:45:00', TRUE),
('m.laurent@entreprise.com', 'c.vincent@entreprise.com', 'Entretien annuel', 'Votre entretien annuel d\'évaluation est planifié pour le jeudi 11 juin à 14h.', '2026-06-08 10:00:00', FALSE),
('c.vincent@entreprise.com', 'm.laurent@entreprise.com', 'Re: Entretien annuel', 'C\'est bien noté, merci Marie.', '2026-06-08 11:30:00', TRUE),
('m.laurent@entreprise.com', 'j.francois@entreprise.com', 'Entretien annuel', 'Votre entretien annuel d\'évaluation est planifié pour le jeudi 11 juin à 15h30.', '2026-06-08 10:05:00', FALSE),
('j.francois@entreprise.com', 'm.laurent@entreprise.com', 'Re: Entretien annuel', 'Entendu, je prépare mon auto-évaluation.', '2026-06-08 14:00:00', TRUE),
('m.laurent@entreprise.com', 'a.girard@entreprise.com', 'Entretien annuel', 'Votre entretien annuel d\'évaluation est planifié pour le vendredi 12 juin à 09h30.', '2026-06-08 10:10:00', FALSE),
('admin@entreprise.com', 'm.fontaine@entreprise.com', 'Alerte sécurité réseau', 'Une tentative d\'accès suspecte a été détectée sur le serveur principal hier soir.', '2026-06-09 08:30:00', FALSE),
('m.fontaine@entreprise.com', 'admin@entreprise.com', 'Re: Alerte sécurité réseau', 'Je lance une analyse complète des logs et renforce les règles de pare-feu.', '2026-06-09 09:15:00', FALSE),
('m.laurent@entreprise.com', 'z.lemaire@entreprise.com', 'Fin de stage', 'Pensez à m\'envoyer votre rapport de stage pour signature avant la fin de semaine.', '2026-06-09 11:00:00', FALSE),
('z.lemaire@entreprise.com', 'm.laurent@entreprise.com', 'Re: Fin de stage', 'Oui, je vous l\'envoie d\'ici demain après-midi.', '2026-06-09 11:45:00', TRUE);