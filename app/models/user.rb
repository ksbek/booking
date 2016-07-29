class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:stripe_connect]

  enum gender: { male: 0, female: 1, other: 2 }
  enum role: { admin: 0, user: 1, performer: 2 }

  belongs_to :profile_picture, class_name: 'Picture'
  has_many :pictures, as: :imageable
  has_many :addresses
  has_many :bookings, dependent: :destroy
  has_many :shows, dependent: :destroy
  belongs_to :art
  has_many :ratings, source: :ratings
  has_many :show_bookings, through: :shows, source: :bookings
  has_many :reviews, through: :show_bookings
  has_many :payment_methods
  has_many :showcases, dependent: :destroy
  has_many :languages_user
  has_many :languages, through: :languages_user
  has_many :availabilities, class_name: 'UserAvailability', dependent: :destroy
  has_many :credit_cards, dependent: :destroy

  accepts_nested_attributes_for :addresses, reject_if: :reject_addresses
  accepts_nested_attributes_for :payment_methods,
                                reject_if: :reject_payment_methods
  accepts_nested_attributes_for :showcases, allow_destroy: true
  accepts_nested_attributes_for :availabilities
  accepts_nested_attributes_for :profile_picture

  validates :firstname, :surname, presence: true
  validates :email, format: {
    with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create
  }
  validate :user_is_performer, if: 'art.present?'

  before_save :deactivate_shows
  before_save :check_profile_picture_exists
  after_create :send_welcome_email

  scope :performers, -> { where role: roles[:performer] }

  attr_accessor :unavailable

  def sent_reviews
    bookings.includes(:review).inject([]) do |reviews, b|
      reviews << b.review if b.review
    end
  end


  def full_name
    "#{firstname} #{surname}"
  end

  def current_bookings
    bookings
      .where('date >= ? and (status = 1 or status = 2)', Time.zone.now)
      .order('date desc')
  end

  def old_bookings
    bookings.where('date < ? and (status = 1)', Time.zone.now)
            .order('date desc')
  end

  def cancelled_bookings
    bookings.where('(status = 3 or status = 4)', Time.zone.now)
            .order('date desc')
  end

  def rating
    [ratings.average(:value).to_i, 5].min
  end

  def available_languages
    @available_languages = []
    languages.each do |language|
      @available_languages.push(language.title)
    end
    @available_languages.join(', ')
  end

  def self.available_languages
    Language.select(:title, :id)
  end

  def image
    pictures.first.try(:image).try(:url, :thumb) || Picture.default_url(:thumb)
  end

  def active_shows
    shows.where(active: true)
  end

  def pictures=(array)
    array.each do |file|
      pictures.build(image: file)
    end
  end

  private

  def check_profile_picture_exists
    self.profile_picture = build_profile_picture if self.profile_picture.nil?
  end

  def reject_addresses(attrs)
    attrs['country'].blank? && attrs['postcode'].blank? &&
      attrs['state'].blank? && attrs['city'].blank? && attrs['street'].blank?
  end

  def reject_payment_methods(attrs)
    attrs['stripe_token'].blank? && attrs['last4'].blank?
  end

  def deactivate_shows
    shows.update_all(active: false) unless phone_number.present?
  end


  def user_is_performer
    errors.add(:art, 'A user should be performer') unless performer?
  end

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_later
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  role                   :integer          default(1)
#  firstname              :string
#  surname                :string
#  gender                 :integer
#  bio                    :text
#  phone_number           :string
#  dob                    :date
#  activity               :string
#  moving                 :boolean
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  profile_picture_id     :integer
#  nickname               :string
#  customer_id            :string
#  stripe_pub_key         :string
#  stripe_user_id         :string
#  stripe_access_code     :string
#  art_id                 :integer
#
# Indexes
#
#  index_users_on_art_id                (art_id)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_profile_picture_id    (profile_picture_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_f005fe78ac  (art_id => arts.id)
#
