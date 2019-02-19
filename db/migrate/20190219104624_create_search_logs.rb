class CreateSearchLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :search_logs do |t|
      t.references :site, foreign_key: true
      t.text :search_string
      t.datetime :start_time
      t.datetime :end_time
      t.text :api_response

      t.timestamps
    end
  end
end
