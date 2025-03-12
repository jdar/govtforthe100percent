class AddTitleToExperiences < ActiveRecord::Migration[7.1]
  def change
    change_table :experiences do |t|
      t.string  :title, limit: 200, null: false, default: "default title"
    end
  end
end
