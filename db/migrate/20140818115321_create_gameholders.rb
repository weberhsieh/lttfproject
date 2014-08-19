class CreateGameholders < ActiveRecord::Migration
  def change
    create_table :gameholders do |t|
      t.integer :user_id
      t.string :name
      t.string :court_name
      t.string :city
      t.string :county
      t.string :zipcode
      t.text :address
      t.float :lng
      t.float :lat
      t.string :phone
      t.string :sponsor

      t.timestamps
    end
    add_index :gameholders, :user_id
    add_index :gameholders, :city
    add_index :gameholders, :county
    add_index :gameholders, :zipcode
  end
end
