class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.string :brand
      t.string :country
      t.integer :exp_month
      t.integer :exp_year
      t.string :funding
      t.string :last4
      t.string :stripe_id
      t.boolean :default, default: false
      t.belongs_to :user

      t.timestamps null: false
    end
  end
end
