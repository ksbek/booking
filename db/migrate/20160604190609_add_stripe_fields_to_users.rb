class AddStripeFieldsToUsers < ActiveRecord::Migration
  def change
    # for regular user
    add_column :users, :customer_id, :string

    # for performer, stripe standalone connect
    add_column :users, :stripe_pub_key, :string
    add_column :users, :stripe_user_id, :string
    add_column :users, :stripe_access_code, :string
  end
end
