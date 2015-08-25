class CreateFaculties < ActiveRecord::Migration
  def change
    create_table :faculties do |t|
      t.integer :datatel_id
      t.string :last_name
      t.string :first_name
      t.string :full_name
      t.string :email
      t.string :phone
      t.string :building_name
      t.string :office_name
      t.string :building_name_2
      t.string :office_name_2

      t.timestamps null: false
    end
  end
end
