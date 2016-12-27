class AddEmailIndexToUsers < ActiveRecord::Migration
  def change
    # add_index does not enforce uniqueness
    add_index :users, :email, unique: true
  end
end
