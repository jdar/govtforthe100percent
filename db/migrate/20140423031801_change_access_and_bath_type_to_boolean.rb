class ChangeAccessAndBathTypeToBoolean < ActiveRecord::Migration[4.2]
  def up
    # If access is 1 it is accessible
    # If bath_type is 0 it is unisex
    connection.execute(%q{
      ALTER TABLE experiences ALTER access TYPE bool
      USING CASE WHEN access=0 THEN FALSE
                 ELSE TRUE END;

      ALTER TABLE experiences ALTER bath_type TYPE bool
      USING CASE WHEN bath_type=1 THEN FALSE
                 ELSE TRUE END;
    })

    change_table :experiences do |t|
      t.rename :access, :accessible
      t.rename :bath_type, :unisex
    end

    change_column :experiences, :accessible, :boolean, default: false
    change_column :experiences, :unisex, :boolean, default: false
  end

  def down
    change_table :experiences do |t|
      t.rename :accessible, :access
      t.rename :unisex, :bath_type
    end

    connection.execute(%q{
      ALTER TABLE experiences ALTER access DROP DEFAULT;
      ALTER TABLE experiences ALTER access TYPE integer
      USING CASE WHEN access=TRUE THEN 1
                 ELSE 0 END;

      ALTER TABLE experiences ALTER bath_type DROP DEFAULT;
      ALTER TABLE experiences ALTER bath_type TYPE integer
      USING CASE WHEN bath_type=FALSE THEN 1
                 ELSE 0 END;
    })
  end
end
