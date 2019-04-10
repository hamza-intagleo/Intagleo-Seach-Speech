class AddNewColumnsIntoSiteConfiguration < ActiveRecord::Migration[5.2]
  def change
    add_column :site_configurations, :widget_fill_color, :string
    add_column :site_configurations, :widget_border_color, :string
    add_column :site_configurations, :widget_shape, :string
    add_column :site_configurations, :widget_fill_color_hover, :string
    add_column :site_configurations, :widget_icon_color, :string
    add_column :site_configurations, :widget_icon_color_hover, :string
    add_column :site_configurations, :widget_fill_color_active, :string
    add_column :site_configurations, :widget_icon_color_active, :string
    add_column :site_configurations, :widget_border_color_active, :string
    add_column :site_configurations, :widget_placeholder_text, :string
    add_column :site_configurations, :widget_placeholder_text_color, :string
    add_column :site_configurations, :widget_text_border_color, :string
  end
end
