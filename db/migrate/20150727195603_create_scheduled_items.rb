class CreateScheduledItems < ActiveRecord::Migration
  def change
    create_table :scheduled_items do |t|
      t.string :date
      t.string :time
      t.string :image
      t.string :name
      t.text :content
      t.string :admission
      t.string :audience
      t.string :location

      t.timestamps null: false
    end
  end
end
