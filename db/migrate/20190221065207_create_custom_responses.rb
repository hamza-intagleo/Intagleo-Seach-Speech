class CreateCustomResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_responses do |t|
      t.references :site, foreign_key: true
      t.string :searched_text
      t.string :target_url
      t.integer :search_ranking

      t.timestamps
    end
  end
end
