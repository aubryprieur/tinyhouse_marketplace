class AddImageUrlToHouses < ActiveRecord::Migration[7.1]
  def change
    add_column :houses, :image_url, :string
  end
end
