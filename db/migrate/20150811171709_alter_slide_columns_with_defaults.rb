class AlterSlideColumnsWithDefaults < ActiveRecord::Migration
  def up
    change_column :slides, :show,     :boolean, null: false, default: true
    change_column :slides, :duration, :integer, null: false, default: 20
  end

  def down
    change_column :slides, :show,     :boolean
    change_column :slides, :duration, :integer
  end
end