class AddReferenceArtToUser < ActiveRecord::Migration
  def change
  	remove_column :users, :art_id
  	add_reference :users, :art, index: true, foreign_key: true
  end
end
