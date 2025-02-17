class SetEditIdToId < ActiveRecord::Migration[5.1]
  def change
    Travesty.update_all('edit_id = id')
  end
end
