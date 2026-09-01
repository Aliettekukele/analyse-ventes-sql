```sql
-- ============================================================
-- PROJET 2 : ANALYSE DES VENTES AVEC SQL
-- ============================================================
-- Dataset : Sales_April_2019.csv
-- Base de données : supermarche
-- Tables : ventes, produits
--
-- Objectif :
-- Analyser les ventes du mois d'avril 2019 afin d'identifier
-- les produits, catégories, villes et heures générant le
-- plus de ventes et de chiffre d'affaires.
-- ============================================================


-- ============================================================
-- 1. CONTROLE DE LA QUALITE DES DONNEES
-- ============================================================

-- Nombre total de lignes importées
SELECT COUNT(*) AS nombre_lignes
FROM ventes;


-- Nombre de lignes avec un order_id vide
SELECT COUNT(*) AS order_id_vides
FROM ventes
WHERE order_id = '';


-- Nombre de lignes avec une quantité égale à zéro
SELECT COUNT(*) AS quantite_zero
FROM ventes
WHERE quantity_ordered = 0;


-- Nombre de lignes considérées comme valides pour l'analyse
SELECT COUNT(*) AS lignes_valides
FROM ventes
WHERE order_id != ''
  AND quantity_ordered > 0
  AND product != ''
  AND order_date != ''
  AND purchase_address != '';


-- Aperçu des données
SELECT *
FROM ventes
LIMIT 10;


-- ============================================================
-- 2. ANALYSE DES PRODUITS
-- ============================================================

-- Quantité totale vendue par produit
SELECT
    product,
    SUM(quantity_ordered) AS quantite_vendue
FROM ventes
WHERE order_id != ''
  AND quantity_ordered > 0
  AND product != ''
GROUP BY product
ORDER BY quantite_vendue DESC;


-- Chiffre d'affaires par produit
SELECT
    product,
    SUM(quantity_ordered * price_each) AS chiffre_affaires
FROM ventes
WHERE order_id != ''
  AND quantity_ordered > 0
  AND product != ''
GROUP BY product
ORDER BY chiffre_affaires DESC;


-- Quantité vendue et chiffre d'affaires par produit
SELECT
    product,
    SUM(quantity_ordered) AS quantite_vendue,
    SUM(quantity_ordered * price_each) AS chiffre_affaires
FROM ventes
WHERE order_id != ''
  AND quantity_ordered > 0
  AND product != ''
GROUP BY product
ORDER BY chiffre_affaires DESC;


-- Produits dont le prix unitaire est supérieur à 500 $
SELECT
    product,
    quantity_ordered,
    price_each
FROM ventes
WHERE order_id != ''
  AND quantity_ordered > 0
  AND product != ''
  AND price_each > 500
ORDER BY price_each DESC;


-- ============================================================
-- 3. ANALYSE PAR CATEGORIE
-- ============================================================

-- Chiffre d'affaires et quantité vendue par catégorie
SELECT
    produits.category,
    SUM(ventes.quantity_ordered) AS quantite_vendue,
    SUM(ventes.quantity_ordered * ventes.price_each) AS chiffre_affaires
FROM ventes
JOIN produits
    ON ventes.product = produits.product
WHERE ventes.order_id != ''
  AND ventes.quantity_ordered > 0
  AND ventes.product != ''
GROUP BY produits.category
ORDER BY chiffre_affaires DESC;


-- ============================================================
-- 4. CHIFFRE D'AFFAIRES GLOBAL
-- ============================================================

-- Chiffre d'affaires total sur les lignes valides
SELECT
    SUM(quantity_ordered * price_each) AS chiffre_affaires_total
FROM ventes
WHERE order_id != ''
  AND quantity_ordered > 0
  AND product != '';


-- ============================================================
-- 5. ANALYSE GEOGRAPHIQUE
-- ============================================================

-- Chiffre d'affaires par ville
SELECT
    TRIM(
        SUBSTRING_INDEX(
            SUBSTRING_INDEX(purchase_address, ',', 2),
            ',',
            -1
        )
    ) AS ville,
    SUM(quantity_ordered * price_each) AS chiffre_affaires
FROM ventes
WHERE order_id != ''
  AND quantity_ordered > 0
  AND product != ''
  AND purchase_address != ''
GROUP BY ville
ORDER BY chiffre_affaires DESC;


-- Nombre de ventes, quantité vendue et chiffre d'affaires
-- par ville
SELECT
    TRIM(
        SUBSTRING_INDEX(
            SUBSTRING_INDEX(purchase_address, ',', 2),
            ',',
            -1
        )
    ) AS ville,
    COUNT(*) AS nombre_ventes,
    SUM(quantity_ordered) AS quantite_vendue,
    SUM(quantity_ordered * price_each) AS chiffre_affaires
FROM ventes
WHERE order_id != ''
  AND quantity_ordered > 0
  AND product != ''
  AND purchase_address != ''
GROUP BY ville
ORDER BY chiffre_affaires DESC;


-- ============================================================
-- 6. ANALYSE TEMPORELLE
-- ============================================================

-- Nombre de ventes par heure
SELECT
    HOUR(
        STR_TO_DATE(order_date, '%m/%d/%y %H:%i')
    ) AS heure,
    COUNT(*) AS nombre_ventes
FROM ventes
WHERE order_id != ''
  AND quantity_ordered > 0
  AND product != ''
  AND order_date != ''
GROUP BY heure
ORDER BY nombre_ventes DESC;


-- Chiffre d'affaires et nombre de ventes par heure
SELECT
    HOUR(
        STR_TO_DATE(order_date, '%m/%d/%y %H:%i')
    ) AS heure,
    COUNT(*) AS nombre_ventes,
    SUM(quantity_ordered * price_each) AS chiffre_affaires
FROM ventes
WHERE order_id != ''
  AND quantity_ordered > 0
  AND product != ''
  AND order_date != ''
GROUP BY heure
ORDER BY chiffre_affaires DESC;


-- ============================================================
-- 7. REQUETE DE SYNTHESE
-- ============================================================

-- Résumé du chiffre d'affaires par catégorie
SELECT
    produits.category,
    COUNT(*) AS nombre_ventes,
    SUM(ventes.quantity_ordered) AS quantite_vendue,
    SUM(ventes.quantity_ordered * ventes.price_each) AS chiffre_affaires
FROM ventes
JOIN produits
    ON ventes.product = produits.product
WHERE ventes.order_id != ''
  AND ventes.quantity_ordered > 0
  AND ventes.product != ''
GROUP BY produits.category
ORDER BY chiffre_affaires DESC;
```
