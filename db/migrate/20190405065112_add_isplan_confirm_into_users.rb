class AddIsplanConfirmIntoUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_plan_confirm, :boolean, default: false
    add_column :users, :stripe_token, :string
    add_column :users, :customer_id, :string
    add_column :users, :subscription_id, :string
    add_column :users, :active_until, :datetime
  end
end
