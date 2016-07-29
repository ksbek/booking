json.id @user.id
json.email @user.email
json.role @user.role
json.firstname @user.firstname
json.surname @user.surname
json.gender @user.gender
json.bio @user.bio
json.phone_number @user.phone_number
json.dob @user.dob
json.activity @user.activity
json.moving @user.moving
json.art_id @user.art_id
json.profile_picture_id @user.profile_picture_id
json.nickname @user.nickname
json.language_ids @user.language_ids

json.profile_picture do
  json.id @user.profile_picture.try(:id)
  json.src @user.profile_picture.try(:src)
end

json.addresses @user.addresses do |address|
  json.merge! address.attributes
  json.full_address address.full_address
end

if @user.performer?
  json.credit_cards @user.credit_cards do |card|
    json.merge! card.attributes
  end
  json.stripe_connected @user.stripe_user_id.present?
elsif @user.user?
  json.credit_cards @user.credit_cards do |card|
    json.merge! card.attributes
  end
end

json.reviews @user.reviews.includes(booking: [user: [:profile_picture, :ratings]]) do |review|
  json.merge! review.attributes
  json.userImageUrl review.try(:booking).try(:user).try(:profile_picture).try(:image).try(:url, :thumb)
  json.bookingUserFullName review.try(:booking).try(:user).try(:full_name)
  json.bookingUserRating review.try(:booking).try(:user).try(:rating)
end

json.sent_reviews @user.sent_reviews do |review|
  json.merge! review.attributes
  json.userImageUrl review.try(:booking).try(:user).try(:profile_picture).try(:image).try(:url, :thumb)
  json.bookingUserFullName review.try(:booking).try(:user).try(:full_name)
  json.bookingUserRating review.try(:booking).try(:user).try(:rating)
end

json.payment_methods @user.payment_methods do |payment_method|
  json.merge! payment_method.attributes
end

json.available_languages  User.available_languages do |language|
  json.merge! language.attributes
end