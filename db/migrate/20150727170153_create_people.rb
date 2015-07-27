class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :location
      t.string :email
      t.string :image

      t.timestamps null: false
    end
  end
end
