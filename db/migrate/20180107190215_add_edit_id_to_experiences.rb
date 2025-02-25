class AddEditIdToExperiences < ActiveRecord::Migration[5.1]
  def change
    add_column :experiences, :edit_id, :integer, :default => 0
  end
end
