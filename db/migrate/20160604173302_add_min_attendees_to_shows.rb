class AddMinAttendeesToShows < ActiveRecord::Migration
  def change
    add_column :shows, :min_attendees, :integer
  end
end
