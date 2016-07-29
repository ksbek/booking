class CreditCard < ActiveRecord::Base
  belongs_to :user

  def set_default!
    user.credit_cards.update_all(default: false)
    self.update(default: true)
  end
end

# == Schema Information
#
# Table name: credit_cards
#
#  id         :integer          not null, primary key
#  brand      :string
#  country    :string
#  exp_month  :integer
#  exp_year   :integer
#  funding    :string
#  last4      :string
#  stripe_id  :string
#  default    :boolean          default(FALSE)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
