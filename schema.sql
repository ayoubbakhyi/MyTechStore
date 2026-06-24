CREATE DATABASE IF NOT EXISTS mytechstore CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE mytechstore;

-- Disable foreign key checks to allow dropping tables in any order
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS livraison;
DROP TABLE IF EXISTS panier_produit;
DROP TABLE IF EXISTS panier;
DROP TABLE IF EXISTS ligne_commande;
DROP TABLE IF EXISTS commande;
DROP TABLE IF EXISTS produit;
DROP TABLE IF EXISTS promotion;
DROP TABLE IF EXISTS categorie;
DROP TABLE IF EXISTS utilisateur;

SET FOREIGN_KEY_CHECKS = 1;

-- Users
CREATE TABLE utilisateur (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    mot_de_passe VARCHAR(255) NOT NULL,
    role ENUM('CLIENT', 'ADMIN') DEFAULT 'CLIENT',
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categories
CREATE TABLE categorie (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL UNIQUE
);

-- Promotions
CREATE TABLE promotion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100),
    type ENUM('POURCENTAGE', 'PRIX_FIXE') NOT NULL,
    valeur DECIMAL(10,2) NOT NULL,
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    actif BOOLEAN DEFAULT TRUE
);

-- Products
CREATE TABLE produit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(200) NOT NULL,
    description TEXT,
    prix DECIMAL(10,2) NOT NULL,
    image VARCHAR(255),
    stock INT DEFAULT 0,
    marque VARCHAR(100),
    id_categorie INT,
    id_promotion INT,
    FOREIGN KEY (id_categorie) REFERENCES categorie(id) ON DELETE SET NULL,
    FOREIGN KEY (id_promotion) REFERENCES promotion(id) ON DELETE SET NULL
);

-- Orders
CREATE TABLE commande (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date_commande TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    statut ENUM('EN_ATTENTE', 'CONFIRMEE', 'EXPEDIEE', 'LIVREE', 'ANNULEE') DEFAULT 'EN_ATTENTE',
    total DECIMAL(10,2) DEFAULT 0,
    id_utilisateur INT NOT NULL,
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id) ON DELETE CASCADE
);

-- Order lines
CREATE TABLE ligne_commande (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_commande INT NOT NULL,
    id_produit INT NOT NULL,
    quantite INT NOT NULL,
    prix_unitaire DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_commande) REFERENCES commande(id) ON DELETE CASCADE,
    FOREIGN KEY (id_produit) REFERENCES produit(id) ON DELETE CASCADE
);

-- Cart
CREATE TABLE panier (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_utilisateur INT NOT NULL UNIQUE,
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id) ON DELETE CASCADE
);

CREATE TABLE panier_produit (
    id_panier INT NOT NULL,
    id_produit INT NOT NULL,
    quantite INT NOT NULL DEFAULT 1,
    PRIMARY KEY (id_panier, id_produit),
    FOREIGN KEY (id_panier) REFERENCES panier(id) ON DELETE CASCADE,
    FOREIGN KEY (id_produit) REFERENCES produit(id) ON DELETE CASCADE
);

-- Deliveries
CREATE TABLE livraison (
    id INT AUTO_INCREMENT PRIMARY KEY,
    adresse VARCHAR(300) NOT NULL,
    ville VARCHAR(100),
    code_postal VARCHAR(20),
    statut ENUM('EN_PREPARATION', 'EXPEDIEE', 'LIVREE') DEFAULT 'EN_PREPARATION',
    date_expedition DATE,
    date_livraison_prevue DATE,
    id_commande INT NOT NULL UNIQUE,
    FOREIGN KEY (id_commande) REFERENCES commande(id) ON DELETE CASCADE
);

-- ─── SEED DATA ───────────────────────────────────────────────

-- Admin account (password: admin123 — BCrypt hash)
INSERT INTO utilisateur (nom, email, mot_de_passe, role)
VALUES ('Admin', 'admin@mytechstore.com', '$2a$10$uD25vcurE7.uYNq0y1VaIOJD3zWhGrgJ9OpnxOPjnCRz9H98WA80K', 'ADMIN');

-- Categories
INSERT INTO categorie (nom) VALUES
('PC Portable'), ('PC Gamer'), ('Carte Graphique'), ('Processeur'),
('RAM & SSD'), ('Clavier Gaming'), ('Souris Gaming'), ('Écran'), ('Casque Audio');

-- Sample promotion
INSERT INTO promotion (nom, type, valeur, date_debut, date_fin)
VALUES ('Soldes Été', 'POURCENTAGE', 15.00, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY));

-- Sample products
INSERT INTO produit (nom, description, prix, stock, marque, id_categorie, id_promotion) VALUES
('HP Pavilion 15', 'PC portable performant Intel Core i5, 8Go RAM, 512Go SSD', 6999.00, 20, 'HP', 1, 1),
('Dell XPS 15', 'Ultrabook premium Intel Core i7, 16Go RAM, 1To SSD, écran 4K', 12999.00, 10, 'Dell', 1, NULL),
('ASUS ROG Strix G15', 'PC gamer AMD Ryzen 9, RTX 3080, 32Go RAM, 1To SSD', 18999.00, 8, 'ASUS', 2, NULL),
('MSI Katana GF66', 'PC gamer Intel Core i7, RTX 3070, 16Go RAM, 512Go SSD', 11999.00, 15, 'MSI', 2, 1),
('NVIDIA RTX 4070', 'Carte graphique haute performance, 12Go GDDR6X', 5999.00, 25, 'NVIDIA', 3, NULL),
('AMD RX 7700 XT', 'Carte graphique AMD, 12Go GDDR6, excellent rapport qualité/prix', 4499.00, 30, 'AMD', 3, NULL),
('Intel Core i9-13900K', 'Processeur haut de gamme, 24 cœurs, 5.8GHz boost', 5499.00, 20, 'Intel', 4, NULL),
('AMD Ryzen 9 7900X', 'Processeur AMD série 7000, 12 cœurs, 5.6GHz boost', 4999.00, 18, 'AMD', 4, 1),
('Kingston Fury 32Go DDR5', 'RAM gaming DDR5 6000MHz, kit 2x16Go', 1299.00, 50, 'Kingston', 5, NULL),
('Samsung 990 Pro 2To', 'SSD NVMe PCIe 4.0 ultra-rapide, 7450Mo/s lecture', 1799.00, 40, 'Samsung', 5, NULL),
('Logitech G Pro X', 'Clavier gaming mécanique switches GX Blue, RGB', 1499.00, 35, 'Logitech', 6, NULL),
('Razer BlackWidow V3', 'Clavier gaming mécanique switches Razer Green, RGB Chroma', 1399.00, 30, 'Razer', 6, 1),
('Logitech G502 X Plus', 'Souris gaming sans fil, 25600 DPI, 89g', 1599.00, 45, 'Logitech', 7, NULL),
('Razer DeathAdder V3', 'Souris gaming ergonomique, capteur Focus Pro 30K, 59g', 899.00, 60, 'Razer', 7, NULL),
('LG 27GP850-B', 'Écran gaming 27" QHD 165Hz 1ms IPS, G-Sync Compatible', 3499.00, 20, 'LG', 8, 1),
('Samsung Odyssey G7 32"', 'Écran gaming courbé 32" QHD 240Hz, QLED', 6999.00, 12, 'Samsung', 8, NULL),
('SteelSeries Arctis 7+', 'Casque gaming sans fil, 30h autonomie, son surround', 1499.00, 25, 'SteelSeries', 9, NULL),
('HyperX Cloud II', 'Casque gaming filaire, micro amovible, son 7.1 virtuel', 799.00, 50, 'HyperX', 9, 1);
