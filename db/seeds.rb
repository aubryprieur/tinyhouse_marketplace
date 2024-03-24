# Création d'utilisateurs
user1 = User.create!(email: 'user1@example.com', password: 'password', password_confirmation: 'password', role: 'seller')
user2 = User.create!(email: 'user2@example.com', password: 'password', password_confirmation: 'password', role: 'buyer')

# Assurez-vous d'avoir configuré votre modèle User avec 'devise' et le champ 'role' si vous suivez cet exemple

# Création de maisons
House.create!(title: 'Tiny House dans la forêt', description: 'Une belle petite maison dans la forêt.', price: 50000, user: user1)
House.create!(title: 'Tiny House près de la plage', description: 'Profitez de la mer avec cette tiny house.', price: 75000, user: user1)

puts "Données seedées avec succès !"
