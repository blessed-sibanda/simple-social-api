json.extract! user, :id, :name, :email, :created_at, :updated_at
json.url user_url(user, format: :json)
if (user.avatar.persisted?)
  json.avatar root_url + url_for(user.avatar)
end
