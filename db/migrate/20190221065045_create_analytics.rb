class CreateAnalytics < ActiveRecord::Migration[5.2]
  def change
    create_table :analytics do |t|
      t.references :site, foreign_key: true
      t.string :search_string
      t.float :search_reponse_time
      t.float :text_processing_time

      t.timestamps
    end
  end
end
