json.extract! topic, :id, :title, :user_id, :movie_id, :created_at, :updated_at
json.post topic.post do |post|
    json.id post.id
    json.body post.body
    json.user_id post.user.id
end
