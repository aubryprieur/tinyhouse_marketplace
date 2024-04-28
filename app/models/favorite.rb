class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :house

  # Validations to ensure no duplicate favorites
  validates :user_id, uniqueness: { scope: :house_id }
end
