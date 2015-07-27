class CreateSlides < ActiveRecord::Migration
  def change
    create_table :slides do |t|
      t.string :name
      t.string :template
      t.string :menu_name
      t.string :organizer
      t.string :organizer_id
      t.integer :duration
      t.string :heading
      t.string :subheading
      t.datetime :datetime
      t.string :location
      t.text :content
      t.string :background
      t.string :background_type
      t.string :background_sizing
      t.string :foreground
      t.string :foreground_type
      t.string :foreground_sizing

      t.timestamps null: false
    end
  end
end
