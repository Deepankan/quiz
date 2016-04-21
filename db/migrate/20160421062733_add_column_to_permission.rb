class AddColumnToPermission < ActiveRecord::Migration
  def change
  	add_column :permissions, :subject_class, :string
  end
end
