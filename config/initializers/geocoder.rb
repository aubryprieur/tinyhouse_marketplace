Geocoder.configure(
  # Utiliser Nominatim comme service de géocodage
  lookup: :nominatim,
  # Définir l'en-tête User-Agent avec le nom de votre application et votre adresse email
  http_headers: { "User-Agent" => "Tiny House (aubry.prieur@gmail.com)" },
  use_https: true, # Utiliser HTTPS pour les requêtes est recommandé
  # Nominatim impose des limites de taux pour éviter la surcharge de leur service.
  request_timeout: 1, # Temps d'attente maximal pour une réponse du serveur
  units: :km, # ou :miles pour définir l'unité de mesure par défaut pour les calculs de distance
)
