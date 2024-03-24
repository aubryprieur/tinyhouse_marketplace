class CreateHouses < ActiveRecord::Migration[7.1]
  def change
    create_table :houses do |t|
      t.string :title
      t.text :description
      t.decimal :price
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
