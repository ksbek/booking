class Art < ActiveRecord::Base
  has_many :users

  validates :title, presence: true
end

# == Schema Information
#
# Table name: arts
#
#  id                 :integer          not null, primary key
#  title              :string
#  description        :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :integer
#  main_description   :text
#  italic_description :text
#  banner_url         :text
#
