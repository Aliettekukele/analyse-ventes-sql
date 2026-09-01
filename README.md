# 📊 Projet 2 — Analyse des ventes avec SQL

## 📌 Présentation du projet

Ce projet consiste à analyser les ventes d'un supermarché à partir du fichier **Sales_April_2019.csv**.

L'objectif est de mettre en pratique SQL pour explorer les données, contrôler leur qualité et produire des indicateurs permettant de mieux comprendre les ventes.

Le projet utilise **MySQL** et **phpMyAdmin**.

---

## 🎯 Objectifs

L'analyse cherche notamment à répondre aux questions suivantes :

* Combien de lignes contient le jeu de données ?
* Les données contiennent-elles des valeurs problématiques ?
* Quels sont les produits les plus vendus ?
* Quels produits génèrent le plus de chiffre d'affaires ?
* Quelles catégories génèrent le plus de revenus ?
* Quelle ville génère le plus de chiffre d'affaires ?
* Quelles sont les heures auxquelles les ventes sont les plus importantes ?
* Quels créneaux horaires génèrent le plus de chiffre d'affaires ?

---

## 🗂️ Jeu de données

**Fichier :** `Sales_April_2019.csv`

Le jeu de données contient des informations sur les ventes réalisées en avril 2019.

### Principales colonnes

| Colonne            | Description                  |
| ------------------ | ---------------------------- |
| `order_id`         | Identifiant de la commande   |
| `product`          | Produit vendu                |
| `quantity_ordered` | Quantité commandée           |
| `price_each`       | Prix unitaire                |
| `order_date`       | Date et heure de la commande |
| `purchase_address` | Adresse de livraison/achat   |

Une table complémentaire `produits` a également été créée afin d'associer chaque produit à une catégorie.

---

## 🗄️ Structure de la base de données

### Table `ventes`

```text
ventes
├── order_id
├── product
├── quantity_ordered
├── price_each
├── order_date
└── purchase_address
```

### Table `produits`

```text
produits
├── product
└── category
```

La relation entre les deux tables est basée sur la colonne :

```text
ventes.product = produits.product
```

Cette relation permet d'utiliser `JOIN` pour analyser les ventes par catégorie.

---

# 🔍 1. Contrôle de la qualité des données

La table contient initialement :

**18 384 lignes.**

Le contrôle des données a permis d'identifier :

* **59 lignes avec `order_id` vide**
* **95 lignes avec `quantity_ordered = 0`**

Ces lignes sont considérées comme problématiques pour les analyses commerciales.

Elles ne sont pas supprimées de la table originale.

À la place, les analyses utilisent des conditions permettant de travailler uniquement avec les lignes valides.

Cette approche permet de conserver les données originales tout en évitant que les anomalies faussent les résultats.

---

# 📦 2. Analyse des produits

L'analyse des quantités vendues permet d'identifier les produits les plus demandés.

### Produit le plus vendu

**AAA Batteries (4-pack)**

Quantité vendue :

**2 936 unités**

Les autres produits fortement vendus comprennent notamment :

* AA Batteries (4-pack)
* Lightning Charging Cable
* USB-C Charging Cable
* Wired Headphones

### Chiffre d'affaires par produit

Le produit générant le plus de chiffre d'affaires est :

**Macbook Pro Laptop — 773 500 $**

Cela montre une différence importante entre volume de ventes et chiffre d'affaires.

Un produit peut être vendu en grande quantité sans générer autant de revenus qu'un produit plus cher.

---

# 💰 3. Chiffre d'affaires global

Le chiffre d'affaires total observé dans les données est de :

## **3 396 059,11 $**

Ce résultat est calculé avec :

```sql
SUM(quantity_ordered * price_each)
```

Le chiffre d'affaires est donc calculé à partir de :

```text
quantité vendue × prix unitaire
```

---

# 🏷️ 4. Analyse par catégorie

L'utilisation de `JOIN` entre les tables `ventes` et `produits` permet d'analyser les performances par catégorie.

| Catégorie      | Quantité vendue | Chiffre d'affaires |
| -------------- | --------------: | -----------------: |
| Laptop         |             847 |     1 165 496,08 $ |
| Smartphone     |           1 496 |       923 100,00 $ |
| Monitor        |           2 350 |       622 466,50 $ |
| Audio          |           4 879 |       382 308,46 $ |
| Television     |             459 |       137 700,00 $ |
| Electromenager |             138 |        82 800,00 $ |
| Cable          |           4 641 |        62 572,95 $ |
| Batteries      |           5 758 |        19 615,12 $ |

### Insight principal

La catégorie **Laptop** génère le chiffre d'affaires le plus élevé avec :

**1 165 496,08 $**

À l'inverse, la catégorie **Batteries** possède un volume de vente élevé mais génère un chiffre d'affaires beaucoup plus faible.

Cela illustre encore une fois la différence entre **volume vendu** et **revenus générés**.

---

# 🌎 5. Analyse géographique

La colonne `purchase_address` contient l'adresse complète du client.

Une transformation SQL avec `SUBSTRING_INDEX()` permet d'extraire automatiquement la ville.

### Chiffre d'affaires par ville

| Ville         | Chiffre d'affaires |
| ------------- | -----------------: |
| San Francisco |       817 074,77 $ |
| Los Angeles   |       551 399,07 $ |
| New York City |       446 587,78 $ |
| Boston        |       353 880,16 $ |
| Atlanta       |       284 454,92 $ |
| Seattle       |       276 010,24 $ |
| Dallas        |       252 840,47 $ |
| Portland      |       241 128,11 $ |
| Austin        |       172 683,59 $ |

### Insight principal

**San Francisco** est la ville générant le plus de chiffre d'affaires avec :

## **817 074,77 $**

Elle est suivie par :

* Los Angeles : **551 399,07 $**
* New York City : **446 587,78 $**

L'analyse du nombre de ventes montre également que San Francisco possède le plus grand volume de transactions :

**4 437 ventes**

pour une quantité totale de :

**4 987 unités**

---

# ⏰ 6. Analyse temporelle

La colonne `order_date` contient la date et l'heure de chaque commande.

La fonction `STR_TO_DATE()` permet de convertir la valeur en date/heure, puis `HOUR()` permet d'extraire l'heure.

### Heure avec le plus de ventes

|   Heure | Nombre de ventes | Chiffre d'affaires |
| ------: | ---------------: | -----------------: |
| **19h** |        **1 286** |   **249 265,71 $** |
|     12h |            1 201 |       237 861,09 $ |
|     11h |            1 201 |       222 818,47 $ |
|     18h |            1 227 |       222 620,31 $ |
|     20h |            1 201 |       217 054,46 $ |

### Insight principal

**19h est le créneau le plus important** dans les données étudiées :

* **1 286 ventes**
* **249 265,71 $ de chiffre d'affaires**

Les périodes **11h–14h** et **18h–20h** présentent également une activité importante.

Une entreprise pourrait donc envisager de tester des campagnes marketing renforcées autour de ces créneaux et de mesurer ensuite leur performance réelle.

---

# 💡 Principaux enseignements

L'analyse met en évidence plusieurs tendances :

### 🥇 Produit

Le produit le plus vendu est :

**AAA Batteries (4-pack) — 2 936 unités**

### 💰 Chiffre d'affaires

Le chiffre d'affaires global est de :

**3 396 059,11 $**

### 💻 Catégorie

La catégorie la plus rentable est :

**Laptop — 1 165 496,08 $**

### 🌎 Ville

La ville générant le plus de revenus est :

**San Francisco — 817 074,77 $**

### ⏰ Heure

L'heure présentant le plus de ventes et le plus gros chiffre d'affaires est :

**19h — 1 286 ventes et 249 265,71 $**

---

# 🛠️ Compétences SQL utilisées

Ce projet m'a permis de mettre en pratique :

* `SELECT`
* `WHERE`
* `GROUP BY`
* `ORDER BY`
* `COUNT()`
* `SUM()`
* `JOIN`
* `STR_TO_DATE()`
* `HOUR()`
* `SUBSTRING_INDEX()`
* Alias avec `AS`
* Calculs SQL
* Contrôle de qualité des données
* Analyse de données commerciales

---

# 🧰 Technologies utilisées

* **MySQL**
* **phpMyAdmin**
* **SQL**
* **CSV**
* **WAMP**

---

# 📁 Structure du projet

```text
Projet_SQL_Ventes/
│
├── analyse_ventes.sql
├── README.md
└── Sales_April_2019.csv
```

---

# 🎯 Conclusion

Cette analyse SQL a permis d'explorer les performances commerciales du mois d'avril 2019 sous plusieurs angles : **produits, catégories, villes et heures de vente**.

Les résultats montrent notamment que les ordinateurs portables génèrent une part importante du chiffre d'affaires, que San Francisco est la ville la plus performante et que 19h représente le principal pic d'activité.

Ce projet démontre ma capacité à utiliser SQL pour **nettoyer, explorer, agréger et interpréter des données afin de répondre à des questions métier**.

```
```
