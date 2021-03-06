class Showcase < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true
  validates :url, presence: true
end

# == Schema Information
#
# Table name: showcases
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  kind       :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
