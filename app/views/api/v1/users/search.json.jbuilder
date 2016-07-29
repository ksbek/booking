json.array! @users do |user|
  json.id user.id
  json.firstname user.firstname
  json.surname user.surname
  json.nickname user.nickname
  json.full_name user.full_name
  json.art_id user.art_id
  json.art_title user.art.try(:title) || '-'
  json.rating user.rating
  json.unavailable user.unavailable
  json.activity user.activity
  json.picture_url user.profile_picture.try(:image).try(:url, :medium)
end
