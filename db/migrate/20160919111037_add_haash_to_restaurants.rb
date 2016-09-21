class AddHaashToRestaurants < ActiveRecord::Migration[5.0]
  def change
    add_column :restaurants, :haash, :text
  end
end
