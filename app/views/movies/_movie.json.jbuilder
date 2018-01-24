json.extract! movie, :id, :name, :created_at, :updated_at
json.url movie_url(movie, format: :json)
json.topics	movie.topics	do	|topic|
		json.id	topic.id
		json.title	topic.title
		json.user_id	topic.user.id
		json.posts	topic.posts	do	|post|
				json.id	post.id
				json.body	post.body
				json.user_id	post.user.id
		end
end
