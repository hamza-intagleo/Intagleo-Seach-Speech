class CreateSites < ActiveRecord::Migration[5.2]
  def change
    create_table :sites do |t|
      t.string :site_name
      t.string :site_url
      t.string :company_number

      t.timestamps
    end

    create_table(:users_sites, :id => false) do |t|
      t.references :user
      t.references :site
    end
    
    add_index(:users_sites, [ :user_id, :site_id ])
  end
end
