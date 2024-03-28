class House < ApplicationRecord
  belongs_to :user

  has_many_attached :images

  validate :image_type, :image_count

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
