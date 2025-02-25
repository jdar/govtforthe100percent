class RenameBathroomsToExperiences < ActiveRecord::Migration[4.2]
  def change
    rename_table :bathrooms, :experiences
  end
end
