class ChangeArts < ActiveRecord::Migration
  def change
    change_table :arts do |t|
      t.text :main_description
      t.text :italic_description
      t.text :banner_url
    end
  end
end
