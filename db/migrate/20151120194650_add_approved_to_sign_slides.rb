class AddApprovedToSignSlides < ActiveRecord::Migration
  def change
    add_column :sign_slides, :approved, :boolean, default: false
  end
end
