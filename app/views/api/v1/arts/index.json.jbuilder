json.array! @arts do |art|
  json.id art.id
  json.banner_url image_url(art.banner_url)
  json.description art.description
  json.italic_description art.italic_description
  json.main_description art.main_description
  json.title art.title
  json.user_id art.user_id
end
