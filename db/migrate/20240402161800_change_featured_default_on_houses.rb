class ChangeFeaturedDefaultOnHouses < ActiveRecord::Migration[7.1]
  def change
    change_column_default :houses, :featured, from: nil, to: false
  end
end
