class AddPaymentStatusToHouses < ActiveRecord::Migration[7.1]
  def change
    add_column :houses, :payment_status, :boolean, default: false
    add_column :houses, :stripe_charge_id, :string
  end
end
