class CreateSiteConfigurations < ActiveRecord::Migration[5.2]
  def change
    create_table :site_configurations do |t|
      t.references :site, foreign_key: true
      t.boolean :return_results_on_rendered_page
      t.boolean :return_results_on_customer_webpage
      t.string :search_string_url
      t.string :search_icon_color
      t.string :search_icon_text
      t.string :search_box_size
      t.string :search_box_shape
      t.string :search_box_fill_color
      t.string :search_box_border_color
      t.string :search_box_placeholder_text

      t.timestamps
    end
  end
end
