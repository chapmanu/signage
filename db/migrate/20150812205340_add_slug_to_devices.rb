class AddSlugToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :slug, :string
    add_index :devices, :slug, unique: true
  end
end