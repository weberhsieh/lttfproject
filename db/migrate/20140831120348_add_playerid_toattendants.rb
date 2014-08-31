class AddPlayeridToattendants < ActiveRecord::Migration
  def up
  	 add_column :attendants , :player_id , :integer
  end

  def down
  end
end
