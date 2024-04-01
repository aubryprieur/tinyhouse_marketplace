class AddAddressDetailsToHouses < ActiveRecord::Migration[7.1]
  def change
    add_column :houses, :address, :string
    add_column :houses, :city, :string
    add_column :houses, :postal_code, :string
  end
end
