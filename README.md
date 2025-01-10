# PROJET_Comparateur
Projet Master APE - Comparateur de prix 
# Projet Technique de Programmation  

## Description du projet  
Ce projet consiste à comparer les prix des pommes entre deux supermarchés, Franprix et Carrefour, en utilisant le scraping web et des analyses statistiques. 
Ainsi avec notre programme un consommateur peut retrouver les prix de n'importe quel produit dans divers supermarchés juste en changeant les variables de notre fonctin de récupération de prix.

## Les principales fonctionnalités incluent :

-L'extraction des noms et prix des produits via la bibliothèque RSelenium.
-Le nettoyage et la préparation des données pour une analyse robuste.
-Des visualisations interactives et des statistiques descriptives pour mieux comprendre les variations de prix.


## Pour commencer  

Voici les étapes nécessaires pour commencer avec ce projet. 

### Pré-requis  
Avant de démarrer, assurez-vous d'avoir les éléments suivants :  

- **R** (version 4.0 ou supérieure)
- GECKODRIVER pour les utilistaeurs de firefix
- Javascript installé 
- Les bibliothèques R suivantes :  
  - `RSelenium`  
  - `dplyr`  
  - `ggplot2`  
  - `stringr`  
  - `rvest`  
  - `httr`  
  - `tidyr`  


### Installation  

1. Clonez ce dépôt GitHub sur votre machine locale :  

Installez les bibliothèques R nécessaires :

install.packages(c("RSelenium", "dplyr", "ggplot2", "stringr", "rvest", "httr", "tidyr"))

### Démarrage

Pour exécuter le projet, suivez les étapes ci-dessous :

   1. Ouvrez le fichier projet_technique_de_programmation.Rmd dans RStudio.
   2. Configurez un serveur Selenium :
   3. Exécutez : library(wdman) et démarrez le serveur via geckodriver().
   4. Lancez le script complet pour scraper les données, les nettoyer et générer des visualisations.
   5. Exécutez chaque bloc de code pour récupérer les données, effectuer les analyses et générer les visualisations.
    


Ce projet a été développé avec :

    RStudio - Environnement de développement pour R
    
    RSelenium - Bibliothèque R pour le web scraping avec Selenium
    
    ggplot2 - Librairie R pour la visualisation des données
    

### Contributing

Les contributions sont les bienvenues !
Versions

Dernière version stable : 1.0
Dernière version : 1.0

Liste des versions : Cliquer pour afficher

### Auteurs

    -KAMEDA PATRICE THOMAS alias @patrice20035
    -MAMADOU


