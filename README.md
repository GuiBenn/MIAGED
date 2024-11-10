# MIAGED - Application de Gestion de Vêtements

MIAGED est une application mobile développée en Flutter, inspirée de Vinted, permettant aux utilisateurs de gérer et de visualiser des vêtements, de les ajouter à leur panier, et de consulter leurs informations de profil. 
Ce projet est le MVP de l'application, réalisé en suivant les User Stories du deuxième TP de Développement mobile.

## Fonctionnalités

- **Connexion** : Authentification de l'utilisateur avec les identifiants fournis.
- **Ajouter des vêtements** : Possibilité d'ajouter des articles avec un titre, une taille, une marque, un prix et une image (via lien https).
- **Panier** : Consultation du panier d'articles ajoutés et affichage du prix total.
- **Profil utilisateur** : Visualisation et modification des informations de profil, y compris le nom d'utilisateur, le mot de passe, l'adresse et la date de naissance.
- **Classification d'image** : Fonction de classification automatique des vêtements à partir d'images pour identifier leur catégorie (t-shirt, pantalons, robes, chaussures et chapeau).

## Informations de Connexion

Pour tester l'application, utilisez les identifiants suivants :
- **Utilisateur 1** : 
  - Login : `user1`
  - Mot de passe : `password1`
- **Utilisateur 2** : 
  - Login : `user2`
  - Mot de passe : `password2`

## Prérequis

Avant de commencer, assurez-vous d'avoir :
- Flutter installé ([guide d'installation](https://flutter.dev/docs/get-started/install))
- Un émulateur virtuel ou un appareil physique compatible avec les réglages de l'application. Assurez-vous que la version minimale de SDK est respectée (minSdkVersion : 23).
  
Le projet est déjà configuré avec les fichiers nécessaires pour Firebase et le modèle de classification d'image, donc il n'est pas nécessaire de créer une nouvelle Firestore Database ou de refaire un modèle de classification dés vêtements.

## Installation

1. Clonez le dépôt :
   ```bash
   git clone https://github.com/GuiBenn/MIAGED.git
   cd miaged
   ```

2. Installez les dépendances Flutter :
   ```bash
   flutter get pub
   ```
3. Lancez l'application sur un émulateur ou appareil physique :
   ```bash
   flutter run
   ```

## Structure du Projet

- **`lib/main.dart`** : Point d'entrée principal de l'application, initialise Firebase et les permissions.
- **`lib/login_page.dart`** : Page de connexion pour accéder à l'application.
- **`lib/home_page.dart`** : Page d'accueil avec navigation entre les autres pages "Acheter", "Panier" et "Profil".
- **`lib/addclothes_page.dart`** : Page permettant d'ajouter un vêtement en accédant via le bouton sur la page "Profil".
- **`lib/basket_page.dart`** : Page pour visualiser et gérer le panier de l'utilisateur.
- **`lib/userprofile_page.dart`** : Page de profil pour visualiser et modifier les informations personnelles de l'utilisateur.
- **`lib/clothesdetail_page.dart`** : Page de détails d'un vêtement, permettant de l'ajouter au panier.

## Exemples d'images pour tester la classification

Voici quelques liens d'images HTTPS que vous pouvez utiliser pour tester le modèle de classification :
- [Pantalon 1](https://www.pull-in.com/media/catalog/product/d/n/dng-classicroybeige-6_1.jpg) : `https://www.pull-in.com/media/catalog/product/d/n/dng-classicroybeige-6_1.jpg`
- [Pantalon 2](https://vondutch.fr/12804-superlarge_default/pantalon-cargo-homme-beige-poches-laterales-avec-ecusson-brode-en-coton-icon.jpg) : `https://vondutch.fr/12804-superlarge_default/pantalon-cargo-homme-beige-poches-laterales-avec-ecusson-brode-en-coton-icon.jpg`
- [Robe 1](https://www.cdiscount.com/pdt2/1/7/4/1/700x700/mp55160174/rw/chic-robe-femme-soiree-cocktail-sur-l-epaule-asyme.jpg) : `https://www.cdiscount.com/pdt2/1/7/4/1/700x700/mp55160174/rw/chic-robe-femme-soiree-cocktail-sur-l-epaule-asyme.jpg`
- [Robe 2](https://cdn-img.prettylittlething.com/c/5/b/7/c5b7d6ef2bc55a3c8d407071354fd66202700cd5_CLZ1361_3.JPG?imwidth=600) : `https://cdn-img.prettylittlething.com/c/5/b/7/c5b7d6ef2bc55a3c8d407071354fd66202700cd5_CLZ1361_3.JPG?imwidth=600`
- [Chapeau Melon](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIUp_rznPRx582fph6Yp67KMDdIY--wWA-fQ&s) : `https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIUp_rznPRx582fph6Yp67KMDdIY--wWA-fQ&s`
- [Casquette](https://www.casquette-print.fr/wp-content/uploads/2022/11/casquette-baseball-classic-6-panel-cap-a-personnaliser-MB6118-navy-apercu.png) : `https://www.casquette-print.fr/wp-content/uploads/2022/11/casquette-baseball-classic-6-panel-cap-a-personnaliser-MB6118-navy-apercu.png`
- [Bonnet](https://www.lebonnetfrancais.fr/3925-large_default/le-bonnet-recycle.jpg) : `https://www.lebonnetfrancais.fr/3925-large_default/le-bonnet-recycle.jpg`
- [Chaussures 1](https://statics-cdn-v2.fashionette.net/transform/ba2e3fc4-3752-4a58-aa43-3fb7ef5465bd/A0220916-PDP-1?io=transform:extend,width:728,height:728,background:white&quality=100) : `https://statics-cdn-v2.fashionette.net/transform/ba2e3fc4-3752-4a58-aa43-3fb7ef5465bd/A0220916-PDP-1?io=transform:extend,width:728,height:728,background:white&quality=100`
- [Chaussures 2](https://www.eram.fr/media/catalog/product/W/W/WWWERM_10272510087_0.jpg?optimize=medium&bg-color=255,255,255&fit=bounds&height=1560&width=1560&canvas=1560:1560) : `https://www.eram.fr/media/catalog/product/W/W/WWWERM_10272510087_0.jpg?optimize=medium&bg-color=255,255,255&fit=bounds&height=1560&width=1560&canvas=1560:1560`
- [T-shirt 1](https://www.fatherandsons.fr/media/cache/catalog/product/t/-/cropped/600x844/t-shirt-homme-slim-uni-noir-01110261_06-V2-pa.jpg) : `https://www.fatherandsons.fr/media/cache/catalog/product/t/-/cropped/600x844/t-shirt-homme-slim-uni-noir-01110261_06-V2-pa.jpg`
- [T-shirt 2](https://image.hm.com/assets/hm/45/58/45589d4f97bfb3386e0acf77e4066534c83f7d9d.jpg?imwidth=2160) : `https://image.hm.com/assets/hm/45/58/45589d4f97bfb3386e0acf77e4066534c83f7d9d.jpg?imwidth=2160`
- [Chemise](https://janedeboy-cdn.com/arts/1500/117078_01.jpg) : `https://janedeboy-cdn.com/arts/1500/117078_01.jpg`

Ces liens peuvent être ajoutés dans le champ "Image" de la page "Ajouter un vêtement" pour tester la classification automatique des images.

## Notes de Développement

- Les images pour les vêtements sont stockées sous forme de liens HTTPS dans Firestore Database. Assurez-vous d'avoir une connexion internet active lors du test de l'application.

## Dépendances

Le projet utilise les packages suivants :
- `firebase_core` : Intégration de Firebase.
- `cloud_firestore` : Gestion des données dans Firestore.
- `flutter/material.dart` : Composants UI de Flutter.
- `http` : Gestion des requêtes HTTP pour télécharger des images.
- `tflite_flutter` : Utilisé pour la classification d'images.
- `image` : Manipulation des images avant classification.
- `permission_handler` : Gestion des permissions d'accès au stockage.

## Auteur

- Guillaume BENEZECH-LOUSTALOT-FOREST
- MIAGE IA2
