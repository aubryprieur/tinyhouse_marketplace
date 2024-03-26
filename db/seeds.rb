# db/seeds.rb
require 'faker'

# Nettoyage de la base de données
House.destroy_all
User.destroy_all

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

# Création de maisons avec Faker
10.times do |i|
  house = House.create!(
    title: Faker::Lorem.sentence(word_count: 3),
    description: Faker::Lorem.paragraph(sentence_count: 2),
    price: Faker::Commerce.price(range: 30000..100000),
    user: [user1, user2].sample # Assigner aléatoirement un des utilisateurs créés comme propriétaire
  )

  # Supposons que vous avez des images nommées house1.jpg, house2.jpg, et house3.jpg dans app/assets/images/houses
  if house.persisted?
    image_path = Rails.root.join("app/assets/images/houses/house#{i % 3 + 1}.jpg")
    house.image.attach(io: File.open(image_path), filename: "house#{i % 3 + 1}.jpg")
  end
end

puts "Données seedées avec succès !"
