class AddLeafCoinsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :leaf_coins, :integer
  end
end
