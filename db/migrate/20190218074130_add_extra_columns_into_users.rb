class AddExtraColumnsIntoUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :client_key, :string
    add_column :users, :client_secret, :string
    add_column :users, :contact_number, :string
    add_column :users, :status, :string, default: 'inactive'
    add_reference :users, :plan, foreign_key: true, default: 1
  end
end
