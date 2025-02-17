class RenameBathroomsToTravesties < ActiveRecord::Migration[4.2]
  def change
    rename_table :bathrooms, :travesties
  end
end
