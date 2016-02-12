class CreateSponsorsTable < ActiveRecord::Migration
  def change
    create_table :sponsors do |t|
      t.string :name
      t.string :icon
    end

    add_reference :slides, :sponsor, index: true

  end
end
