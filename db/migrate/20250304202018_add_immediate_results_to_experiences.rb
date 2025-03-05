class AddImmediateResultsToExperiences < ActiveRecord::Migration[7.1]
  def change
    change_column :experiences, :immediate_results, :text, array: true, default: []
  end
end
