class AddProfilePictureToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :profile_picture, index: true, references: :pictures
  end
end
