class House < ApplicationRecord
  belongs_to :user

  has_many_attached :images

  validate :image_type, :image_count
  geocoded_by :full_address
  after_validation :geocode, if: ->(obj){ obj.will_save_change_to_address? || obj.will_save_change_to_city? || obj.will_save_change_to_postal_code? }

  def full_address
    [address, city, postal_code].compact.join(', ')
  end

  private

  def image_type
    images.each do |image|
      if !image.content_type.in?(%('image/jpeg image/png'))
        errors.add(:images, 'doit être au format JPEG ou PNG')
      end
    end
  end

  def image_count
    if images.length > 3
      errors.add(:images, 'Vous ne pouvez pas télécharger plus de 3 images')
    end
  end


end
