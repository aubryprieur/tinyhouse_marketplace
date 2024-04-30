class AddValidatedToHouses < ActiveRecord::Migration[7.1]
  def change
    add_column :houses, :validated, :boolean, default: false
  end
end
