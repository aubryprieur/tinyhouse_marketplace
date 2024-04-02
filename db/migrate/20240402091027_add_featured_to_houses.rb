class AddFeaturedToHouses < ActiveRecord::Migration[7.1]
  def change
    add_column :houses, :featured, :boolean
  end
end
