class AddStuffToRestaurants < ActiveRecord::Migration[5.0]
  def change
    add_column :restaurants, :stuff, :string, array: true, default: []
  end
end
