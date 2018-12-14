class AddAdminToUsers < ActiveRecord::Migration[5.2]
  # Command used to generate this file:
  # rails g migration add_admin_to_users admin:boolean
  def change
    add_column :users, :admin, :boolean, default: false
  end
end
