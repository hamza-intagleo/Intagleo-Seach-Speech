class CreatePlans < ActiveRecord::Migration[5.2]
  def change
    create_table :plans do |t|
      t.string :plan_name
      t.integer :query_limit
      t.float :price
      t.string :duration_type

      t.timestamps
    end
  end
end
