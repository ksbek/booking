class Show < ActiveRecord::Base

  COMMISSION = 1.1
  
  belongs_to :cover_picture, class_name: 'Picture'

  belongs_to :user
  has_one :art, through: :user
  has_many :languages, through: :user

  has_many   :bookings
  has_many   :pictures  , dependent: :destroy , as: :imageable
  has_many :reviews, through: :bookings
  has_many :ratings, through: :reviews

  just_define_datetime_picker :published_at
  validates :length, :title, :description, :price, presence: true
  accepts_nested_attributes_for :pictures, allow_destroy: true

  after_save :set_cover_picture
  before_save :update_rating

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  def as_indexed_json options={}
    self.as_json({
                   only: [:title, :description]
    })
  end

  def reviews_max_3
    reviews.first(3)
  end

  def spectators
    spect = ""
    if min_attendees && max_spectators
      spect += "from " + min_attendees.to_s + " "
      spect += "to " + max_spectators.to_s
      spect.slice(0,1).capitalize + spect.slice(1..-1)
    elsif !min_attendees && !max_spectators
      spect = "Indifférent"
    elsif !min_attendees
      spect = "Maximum " + max_spectators.to_s
    elsif !max_spectators
      spect = "Minimum " + min_attendees.to_s
    end
  end

  def duration
    if length > 59
      return (length / 60).to_s + "h " + (length % 60).to_s.to_s + "min"
    else
      return length.to_s + "min"
    end
    ''
  end

  def toggle_active
    if user && user.addresses.any? && user.phone_number.present?
      self.active = !self.active
      self.save
    else
      if user.addresses.empty?
        self.errors.add(:address, I18n.t('activerecord.errors.messages.addresses_is_empty'))
      elsif user.phone_number.blank?
        self.errors.add(:phone_number, I18n.t('activerecord.errors.messages.phone_number_is_empty'))
      end
    end
  end

  def pictures=(array)
    array.each do |file|
      pictures.build(image: file)
    end
  end

  private

  def set_cover_picture
    picture = self.pictures.select { |p| p.selected }.first
    if picture && picture.id != cover_picture_id
      self.cover_picture = picture
      self.save
    end
  end

  def update_rating
    self.rating = [ratings.average(:value).to_f, 5].min
  end

end

# == Schema Information
#
# Table name: shows
#
#  id               :integer          not null, primary key
#  title            :string
#  length           :integer
#  surface          :integer
#  description      :text
#  price            :float
#  max_spectators   :integer
#  starts_at        :string
#  ends_at          :string
#  active           :boolean
#  published_at     :datetime
#  cover_picture_id :integer
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  rating           :float
#  price_person     :boolean
#  min_attendees    :integer
#
# Indexes
#
#  index_shows_on_cover_picture_id  (cover_picture_id)
#  index_shows_on_user_id           (user_id)
#
