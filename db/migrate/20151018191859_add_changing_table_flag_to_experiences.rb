class AddChangingTableFlagToExperiences < ActiveRecord::Migration[4.2]
  def change
    add_column :experiences, :changing_table, :boolean, default: false
  end
end
