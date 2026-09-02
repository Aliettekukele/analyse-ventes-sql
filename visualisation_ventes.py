import pandas as pd
import matplotlib.pyplot as plt
from pathlib import Path

# ============================================================
# PROJET 2 : VISUALISATION DES VENTES
# ============================================================
# Dataset : Sales_April_2019.csv
# Les graphiques sont enregistrés dans le dossier images/.
# ============================================================

df = pd.read_csv("Sales_April_2019.csv")

# Conversion des types
df["Quantity Ordered"] = pd.to_numeric(df["Quantity Ordered"], errors="coerce")
df["Price Each"] = pd.to_numeric(df["Price Each"], errors="coerce")
df["Order Date"] = pd.to_datetime(
    df["Order Date"],
    format="%m/%d/%y %H:%M",
    errors="coerce"
)

# Nettoyage
df = df.dropna(
    subset=[
        "Order ID", "Product", "Quantity Ordered",
        "Price Each", "Order Date", "Purchase Address"
    ]
)

df = df[
    (df["Order ID"].astype(str).str.strip() != "") &
    (df["Product"].astype(str).str.strip() != "") &
    (df["Quantity Ordered"] > 0) &
    (df["Purchase Address"].astype(str).str.strip() != "")
].copy()

# Chiffre d'affaires
df["Sales"] = df["Quantity Ordered"] * df["Price Each"]

Path("images").mkdir(exist_ok=True)

# 1. Top 10 produits les plus vendus
produits_quantite = (
    df.groupby("Product")["Quantity Ordered"]
    .sum()
    .sort_values(ascending=False)
    .head(10)
    .sort_values()
)

plt.figure(figsize=(10, 6))
produits_quantite.plot(kind="barh")
plt.title("Top 10 des produits les plus vendus")
plt.xlabel("Quantité vendue")
plt.ylabel("Produit")
plt.tight_layout()
plt.savefig("images/ventes_par_produit.png", dpi=150)
plt.show()
plt.close()

# 2. Top 10 produits par chiffre d'affaires
produits_ca = (
    df.groupby("Product")["Sales"]
    .sum()
    .sort_values(ascending=False)
    .head(10)
    .sort_values()
)

plt.figure(figsize=(10, 6))
produits_ca.plot(kind="barh")
plt.title("Top 10 des produits par chiffre d'affaires")
plt.xlabel("Chiffre d'affaires ($)")
plt.ylabel("Produit")
plt.tight_layout()
plt.savefig("images/chiffre_affaires_par_produit.png", dpi=150)
plt.show()
plt.close()

# 3. Catégories utilisées dans l'analyse SQL
categories = {
    "Macbook Pro Laptop": "Laptop",
    "ThinkPad Laptop": "Laptop",
    "Dell Laptop": "Laptop",
    "iPhone": "Smartphone",
    "Google Phone": "Smartphone",
    "Vareebadd Phone": "Smartphone",
    "27in 4K Gaming Monitor": "Monitor",
    "34in Ultrawide Monitor": "Monitor",
    "27in FHD Monitor": "Monitor",
    "20in Monitor": "Monitor",
    "Wired Headphones": "Audio",
    "Apple Airpods Headphones": "Audio",
    "Bose SoundSport Headphones": "Audio",
    "Flatscreen TV": "Television",
    "LG Dryer": "Electromenager",
    "LG Washing Machine": "Electromenager",
    "Lightning Charging Cable": "Cable",
    "USB-C Charging Cable": "Cable",
    "AA Batteries (4-pack)": "Batteries",
    "AAA Batteries (4-pack)": "Batteries"
}

df["Category"] = df["Product"].map(categories)

ca_categories = (
    df.dropna(subset=["Category"])
    .groupby("Category")["Sales"]
    .sum()
    .sort_values(ascending=False)
)

plt.figure(figsize=(10, 6))
ca_categories.plot(kind="bar")
plt.title("Chiffre d'affaires par catégorie")
plt.xlabel("Catégorie")
plt.ylabel("Chiffre d'affaires ($)")
plt.xticks(rotation=45, ha="right")
plt.tight_layout()
plt.savefig("images/chiffre_affaires_par_categorie.png", dpi=150)
plt.show()
plt.close()

# 4. Top 10 villes par chiffre d'affaires
df["City"] = df["Purchase Address"].str.split(",").str[1].str.strip()

ca_villes = (
    df.groupby("City")["Sales"]
    .sum()
    .sort_values(ascending=False)
    .head(10)
    .sort_values()
)

plt.figure(figsize=(10, 6))
ca_villes.plot(kind="barh")
plt.title("Top 10 des villes par chiffre d'affaires")
plt.xlabel("Chiffre d'affaires ($)")
plt.ylabel("Ville")
plt.tight_layout()
plt.savefig("images/chiffre_affaires_par_ville.png", dpi=150)
plt.show()
plt.close()

# 5. Nombre de ventes par heure
df["Hour"] = df["Order Date"].dt.hour

ventes_heure = df.groupby("Hour").size()

plt.figure(figsize=(10, 6))
ventes_heure.sort_index().plot(kind="bar")
plt.title("Nombre de ventes par heure")
plt.xlabel("Heure")
plt.ylabel("Nombre de ventes")
plt.xticks(rotation=0)
plt.tight_layout()
plt.savefig("images/ventes_par_heure.png", dpi=150)
plt.show()
plt.close()

print("==============================================")
print("VISUALISATIONS TERMINEES")
print("==============================================")
print(f"Lignes utilisées : {len(df)}")
print("Les graphiques sont enregistrés dans le dossier images/")
