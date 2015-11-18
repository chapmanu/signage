class CreateSlideUsers < ActiveRecord::Migration
  def change
    create_table :slide_users do |t|
      t.belongs_to :slide, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
