# db/seeds.rb

require 'faker'

# Nettoyage de la base de données
House.destroy_all
User.destroy_all

# Création d'un compte super_admin
super_admin = User.create!(
  email: "superadmin@example.com",
  password: 'password',
  password_confirmation: 'password',
  role: 'super_admin'
)

# Création d'utilisateurs avec Faker
user1 = User.create!(
  email: "seller@gmail.com",
  password: 'password',
  password_confirmation: 'password',
  role: 'seller' # Assurez-vous que votre modèle User peut gérer le champ 'role'
)
user2 = User.create!(
  email: Faker::Internet.email,
  password: 'password',
  password_confirmation: 'password',
  role: 'buyer'
)

# Chemin vers vos images de seed
seed_images = Dir[Rails.root.join('db/seed_images/*')]

# Création de maisons avec des images attachées
10.times do |i|
  house = House.create!(
    title: "Maison #{i}",
    description: "Description pour la maison #{i}",
    price: rand(50000..300000),
    address: Faker::Address.street_address,
    city: Faker::Address.city,
    postal_code: Faker::Address.zip_code,
    featured: [true, false].sample, # Ajouter une valeur aléatoire pour `featured`
    user: [user1, user2].sample # Assigner aléatoirement un des utilisateurs créés comme propriétaire
  )

  # Attacher de 1 à 3 images aléatoirement
  rand(1..3).times do
    image_path = seed_images.sample # Sélectionner une image aléatoire
    house.images.attach(io: File.open(image_path), filename: File.basename(image_path))
  end
end

puts "Données seedées avec succès !"

