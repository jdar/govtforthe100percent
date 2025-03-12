class ChangeTitleOfExperiences < ActiveRecord::Migration[7.1]
  def change
    change_column_default :experiences, :title, ""
  end
end
