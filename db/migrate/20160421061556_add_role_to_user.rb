class AddRoleToUser < ActiveRecord::Migration
  def change
  	add_column :roles, :user_id, :integer
  	add_column :users, :role_id, :integer
  end
end
