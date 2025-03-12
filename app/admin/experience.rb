ActiveAdmin.register Experience do
  permit_params :name, :street, :city, :state, :accessible, :changing_table, :unisex, :directions,
                :comment, :latitude, :longitude, :country, :edit_id, :approved,
                :zip_code, :federal_agency, :agency_website, :experience, :title, :experience_details, :open_to_contact
end
