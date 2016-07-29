json.array!(@shows.includes(:cover_picture, :pictures, :user)) do |show|
  json.merge! show.attributes
  json.user_picture_url show.try(:user).try(:profile_picture).try(:image).try(:url, :thumb)
  json.commission Show::COMMISSION

  json.cover_picture do
    json.id show.cover_picture.id
    json.src show.cover_picture.src
  end if show.cover_picture

  json.pictures show.pictures do |picture|
    json.id picture.id
    json.src picture.src
  end

  json.user do |json|
    json.partial! 'api/v1/users/user', user: show.user
  end if show.user
end
