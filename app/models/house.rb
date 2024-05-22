class House < ApplicationRecord
  belongs_to :user
  has_many :messages
  has_many :favorites
  has_many :favorited_by, through: :favorites, source: :user
  has_many :reports
  has_many_attached :images

  validate :image_type, :image_count
  validate :validate_images_count
  validates :featured, inclusion: { in: [true, false] }

  geocoded_by :full_address

  after_validation :geocode, if: ->(obj){ obj.will_save_change_to_address? || obj.will_save_change_to_city? || obj.will_save_change_to_postal_code? }

  scope :featured, -> { where(featured: true) }

  def full_address
    [address, city, postal_code].compact.join(', ')
  end

  def reported?
    reports.exists?(resolved: false)
  end

  def current_report
    reports.where(resolved: false).first
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

  def validate_images_count
    if images.attached? && images.size > 3 && !payment_status
      errors.add(:images, "Vous ne pouvez pas télécharger plus de 3 images sans paiement.")
    end
  end


end
