class AddApprovedToGameholders < ActiveRecord::Migration
  def change
  	add_column :gameholders, :approved, :boolean
  end
end
