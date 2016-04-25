class AddColumnToUser < ActiveRecord::Migration
  def change
  	add_column :users, :score, :string
  end
end
