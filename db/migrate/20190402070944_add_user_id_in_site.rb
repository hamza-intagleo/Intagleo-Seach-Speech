class AddUserIdInSite < ActiveRecord::Migration[5.2]
  def change
    add_reference :sites, :user, index: true
  end
end
