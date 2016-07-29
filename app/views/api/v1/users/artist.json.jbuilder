json.id @user.id
json.art do
  json.banner_url image_url(@user.art.banner_url)
  json.title @user.art.title
  json.id @user.art.id
end
json.full_name @user.full_name
json.rating @user.rating
json.activity @user.activity
json.nickname @user.nickname

json.profile_picture do
  json.id @user.profile_picture.try(:id)
  json.src @user.profile_picture.try(:src)
end

json.available_languages @user.available_languages
json.picture_url @user.image
json.bio @user.bio
json.moving @user.moving
json.pictures do
  json.array! @user.pictures do |picture|
  	json.id picture.id
  	json.src picture.src
    json.src_original picture.src_original
  end
end

json.showcases @user.showcases
json.shows do
  json.array! @user.active_shows do |show|
  	json.id show.id
  	json.title show.title
  	json.rating show.rating
    json.cover_picture show.cover_picture.image(:large)  if show.cover_picture
  	json.duration show.duration
  	json.description show.description
  	json.price show.price.to_i
    json.price_person show.price_person
    json.spectators show.spectators
    json.min_attendees show.min_attendees
    json.max_spectators show.max_spectators
  	json.reviews do
  	  json.array! show.reviews_max_3 do |review|
  	  	json.review review.review
  	  	json.rating review.rating.value
  	  	json.username review.booking.user.full_name
  	  end
  	end
  	json.pictures do
  	  json.array! show.pictures do |picture|
  	  	json.id picture.id
  	  	json.src picture.src
        json.src_original picture.src_original
  	  end
  	end
  end
end

