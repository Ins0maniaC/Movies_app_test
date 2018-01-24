class Movie < ApplicationRecord
	has_and_belongs_to_many :users, :join_table => :users_movies
	has_many :topics
end
