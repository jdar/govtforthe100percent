class AddChangingTableFlagToTravesties < ActiveRecord::Migration[4.2]
  def change
    add_column :travesties, :changing_table, :boolean, default: false
  end
end
