# db/seeds.rb

require 'faker'

# Nettoyage de la base de données
Report.destroy_all
Favorite.destroy_all
Message.destroy_all
House.destroy_all
User.destroy_all

# Création d'un compte super_admin
super_admin = User.create!(
  email: "admin@gmail.com",
  password: 'password',
  password_confirmation: 'password',
  phone_number: Faker::PhoneNumber.phone_number,
  role: 'super_admin'
)

# Création d'utilisateurs avec Faker
user1 = User.create!(
  email: "user1@gmail.com",
  password: 'password',
  password_confirmation: 'password',
  phone_number: Faker::PhoneNumber.phone_number,
  role: 'seller' # Assurez-vous que votre modèle User peut gérer le champ 'role'
)
user2 = User.create!(
  email: "user2@gmail.com",
  password: 'password',
  password_confirmation: 'password',
  phone_number: Faker::PhoneNumber.phone_number,
  role: 'buyer'
)

# Chemin vers vos images de seed
seed_images = Dir[Rails.root.join('db/seed_images/*')]

# Liste des adresses à ajouter
addresses = [
  { address: "44 rue de la halle", postal_code: "59800", city: "Lille" },
  { address: "25 quai de l’oise", postal_code: "75019", city: "Paris" },
  { address: "Route de Filsac", postal_code: "46100", city: "Figeac" },
  { address: "9 Grande Rue", postal_code: "21200", city: "Ruffey-lès-Beaune" },
  { address: "", postal_code: "19170", city: "Gourdon-Murat" }, # Adresse vide car non spécifiée
  { address: "Rue du Roc", postal_code: "34700", city: "Lodève" },
  { address: "1 Rue de la Paix", postal_code: "04120", city: "Castellane" },
  { address: "", postal_code: "40700", city: "Doazit" }, # Adresse vide car non spécifiée
  { address: "38 Rte du Petit Cougour", postal_code: "03410", city: "Lignerolles" },
  { address: "3-1 Le Cleuziou", postal_code: "", city: "Priziac" } # Code postal vide car non spécifié
]


# Création de maisons avec des adresses spécifiées
addresses.each do |addr|
  house = House.create!(
    title: "Maison à #{addr[:city]}",
    description: Faker::Lorem.sentence(word_count: 10),
    price: rand(50000..300000),
    address: addr[:address],
    postal_code: addr[:postal_code],
    city: addr[:city],
    featured: [true, false].sample,
    user: [user1, user2].sample
  )

  # Attacher de 1 à 3 images aléatoirement
  rand(1..3).times do
    image_path = seed_images.sample # Sélectionner une image aléatoire
    house.images.attach(io: File.open(image_path), filename: File.basename(image_path))
  end
end

puts "Données seedées avec succès !"

