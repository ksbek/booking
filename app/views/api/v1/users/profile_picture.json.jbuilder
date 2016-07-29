json.profile_picture do
  json.id @user.profile_picture.try(:id)
  json.src @user.profile_picture.try(:src)
end
