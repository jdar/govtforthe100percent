class AddEditIdToTravesties < ActiveRecord::Migration[5.1]
  def change
    add_column :travesties, :edit_id, :integer, :default => 0
  end
end
