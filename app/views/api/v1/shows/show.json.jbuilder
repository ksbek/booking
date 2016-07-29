json.merge! @show.attributes
json.user_picture_url @show.try(:user).try(:profile_picture).try(:image).try(:url, :thumb)
json.commission Show::COMMISSION

json.pictures @show.pictures do |picture|
  json.id picture.id
  json.src picture.src
end

json.cover_picture @show.cover_picture.image(:large)  if @show.cover_picture

json.user do
  json.partial! 'api/v1/users/user', user: @show.user
end if @show.user

json.banner_url image_url(@show.user.art.banner_url)
json.art_title @show.user.art.title