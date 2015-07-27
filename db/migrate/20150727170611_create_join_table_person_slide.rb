class CreateJoinTablePersonSlide < ActiveRecord::Migration
  def change
    create_join_table :people, :slides do |t|
      t.index [:person_id, :slide_id]
      t.index [:slide_id, :person_id]
    end
  end
end
