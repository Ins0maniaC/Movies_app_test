class User < ApplicationRecord
	has_and_belongs_to_many :movies, :join_table => :users_movies
	has_many :topics
	has_many :posts
	
    has_secure_password
    has_secure_token
 
    validates :name, presence: true, uniqueness: true, length: { in: 3..50 }
    validates :index, presence: true, length: { is: 6 }, uniqueness: true
    validates :password, presence: true, length: { minimum: 6 }
	
	def follows?(movie)
		self.movies.include?(movie)
	end

    def invalidate_token
    self.update_columns(token: nil)
    end

end
