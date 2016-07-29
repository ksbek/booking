json.extract! user, :id, :email, :role, :firstname, :surname, :gender, :bio, :phone_number, :dob, :activity, :moving, :art_id, :nickname
json.full_name user.full_name
json.profile_picture do
  json.id user.profile_picture.try(:id)
  json.src user.profile_picture.try(:src)
end
