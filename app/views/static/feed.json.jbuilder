json.movies current_user.movies do |movie|
  json.id movie.id
  json.name movie.name
  json.topics movie.topics do |topic|
    json.id topic.id
    json.title topic.title
    json.user_id topic.user.id
    json.posts topic.posts do |post|
      json.id post.id
      json.body post.body
      json.user_id post.user.id
    end
  end
end
