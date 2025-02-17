class AddApprovedToTravesties < ActiveRecord::Migration[5.1]
  def change
    add_column :travesties, :approved, :boolean, :default => true
  end
end
