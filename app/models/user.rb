class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :phone_number, presence: true, uniqueness: true

  has_many :houses, dependent: :destroy
  has_many :messages
  has_many :favorites
  has_many :favorite_houses, through: :favorites, source: :house

  enum role: { super_admin: 0, seller: 1, buyer: 2 }

end
