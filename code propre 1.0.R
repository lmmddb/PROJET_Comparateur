# Charger les bibliothèques nécessaires
library(RSelenium)
library(dplyr)
library(stringr)
library(rvest)
library(httr)
library(wdman)
library(netstat)
library(ggplot2)
library(dplyr)
library(tidyr)

# Fonction pour initialiser RSelenium
start_selenium <- function(browser = "firefox", port = free_port()) {
  rD <- rsDriver(browser = browser, verbose = FALSE, port = port)
  remDr <- rD$client
  list(rD = rD, remDr = remDr)
}

# Fonction pour récupérer les données (noms et prix)
get_apples_data <- function(remDr, url, name_selector, price_selector, delay = 5) {
  # Naviguer vers l'URL
  remDr$navigate(url)
  
  # Attendre le chargement de la page
  Sys.sleep(delay)
  
  # Extraire les noms des produits
  name_elements <- remDr$findElements(using = "css selector", value = name_selector)
  names <- sapply(name_elements, function(el) el$getElementText()) %>% unlist()
  
  # Extraire les prix des produits
  price_elements <- remDr$findElements(using = "css selector", value = price_selector)
  prices <- sapply(price_elements, function(el) el$getElementText()[[1]])
  
  # Nettoyer les prix pour les convertir en format numérique
  prices <- prices %>%
    gsub(",", ".", .) %>%  # Remplacer les virgules par des points
    gsub("[^0-9.]", "", .) %>%  # Supprimer tout sauf les chiffres et les points
    as.numeric()  # Convertir en numérique
  
  # Vérifier les longueurs et ajuster
  if (length(names) > length(prices)) {
    names <- names[1:length(prices)]
  } else if (length(prices) > length(names)) {
    prices <- prices[1:length(names)]
  }
  
  # Créer un data.frame et exclure les lignes avec des prix NA ou nuls
  data <- data.frame(Name = names, Price = prices, stringsAsFactors = FALSE)
  data <- data %>% filter(!is.na(Price) & Price > 0)
  
  return(data)
}

# Initialiser Selenium
sel <- start_selenium()
remDr <- sel$remDr

# URL et sélecteurs CSS pour Franprix
franprix_url <- "https://www.franprix.fr/courses/c/pomme-poire-raisin"
franprix_name_selector <- ".product-item-name"
franprix_price_selector <- ".product-item-price"

# URL et sélecteurs CSS pour Carrefour
carrefour_url <- "https://www.carrefour.fr/r/fruits-et-legumes/fruits/pommes-poires-et-raisins/pommes"
carrefour_name_selector <- "h3.c-text--style-p"
carrefour_price_selector <- ".product-price__content"

# Récupérer les données pour Franprix
franprix_data <- tryCatch({
  get_apples_data(remDr, franprix_url, franprix_name_selector, franprix_price_selector)
}, error = function(e) {
  message("Erreur lors de la récupération des données Franprix : ", e)
  NULL
})

# Récupérer les données pour Carrefour
carrefour_data <- tryCatch({
  get_apples_data(remDr, carrefour_url, carrefour_name_selector, carrefour_price_selector)
}, error = function(e) {
  message("Erreur lors de la récupération des données Carrefour : ", e)
  NULL
})

# Fermer Selenium
remDr$close()
sel$rD$server$stop()

# Afficher les données récupérées
cat("Données Franprix :\n")
print(franprix_data)
cat("\nDonnées Carrefour :\n")
print(carrefour_data)

# Comparer les prix (si les deux jeux de données sont disponibles)
if (!is.null(franprix_data) && !is.null(carrefour_data)) {
  combined_data <- bind_rows(
    franprix_data %>% mutate(Supermarket = "Franprix"),
    carrefour_data %>% mutate(Supermarket = "Carrefour")
  )
  
  cat("\nComparaison des prix :\n")
  print(combined_data)
} else {
  cat("\nImpossible de comparer les prix : données manquantes.\n")
}


# Analyse statistique
stats <- combined_data %>%
  group_by(Supermarket) %>%
  summarise(
    Average_Price = mean(Price, na.rm = TRUE),
    SD_Price = sd(Price, na.rm = TRUE),
    Min_Price = min(Price, na.rm = TRUE),
    Max_Price = max(Price, na.rm = TRUE)
  )

print("Statistiques par supermarché :")
print(stats)



# Visualisation des prix
ggplot(combined_data, aes(x = Supermarket, y = Price, fill = Supermarket)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Distribution des prix par supermarché", x = "Supermarché", y = "Prix (€)")



# Histogramme des prix pour chaque supermarché
ggplot(combined_data, aes(x = Price, fill = Supermarket)) +
  geom_histogram(binwidth = 0.5, position = "dodge", alpha = 0.7) +
  theme_minimal() +
  labs(title = "Histogramme des prix par supermarché",
       x = "Prix (€)",
       y = "Fréquence") +
  scale_fill_manual(values = c("Carrefour" = "blue", "Franprix" = "orange"))

# Nuage de points pour les prix en fonction des produits
ggplot(combined_data, aes(x = Name, y = Price, color = Supermarket)) +
  geom_point(size = 3, alpha = 0.7) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Nuage de points des prix par produit",
       x = "Produit",
       y = "Prix (€)",
       color = "Supermarché") +
  scale_color_manual(values = c("Carrefour" = "blue", "Franprix" = "orange"))

# Boxplot déjà inclus pour comparer les distributions de prix
ggplot(combined_data, aes(x = Supermarket, y = Price, fill = Supermarket)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Distribution des prix par supermarché",
       x = "Supermarché",
       y = "Prix (€)") +
  scale_fill_manual(values = c("Carrefour" = "blue", "Franprix" = "orange"))
