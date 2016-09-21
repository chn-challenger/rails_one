class AddBaseToReviews < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :base, :string
  end
end
