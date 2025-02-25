class AddApprovedToExperiences < ActiveRecord::Migration[5.1]
  def change
    add_column :experiences, :approved, :boolean, :default => true
  end
end
