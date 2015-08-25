class DropPeopleTable < ActiveRecord::Migration
  def change
    drop_table :people do |t|
      t.string :name
      t.string :location
      t.string :email
      t.string :image

      t.timestamps null: false
    end

    drop_join_table :people, :slides do |t|
      t.index [:person_id, :slide_id]
      t.index [:slide_id, :person_id]
    end
  end
end
