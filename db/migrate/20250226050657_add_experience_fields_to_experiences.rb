class AddExperienceFieldsToExperiences < ActiveRecord::Migration[6.1]
  def change
    change_table :experiences do |t|
      t.string  :zip_code,         limit: 5,  null: false
      t.string  :federal_agency,                null: false
      t.string  :agency_website
      t.string  :experience,                    null: false
      t.string  :immediate_results, array: true, default: []
      t.text    :experience_details,            null: false
      t.boolean :open_to_contact,   default: false
      t.string  :contact_name
      t.string  :contact_email
      t.string  :contact_phone
    end
  end
end