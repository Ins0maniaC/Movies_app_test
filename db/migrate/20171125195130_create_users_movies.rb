class CreateUsersMovies < ActiveRecord::Migration[5.1]
  def change
    create_table :users_movies, id: false do |t|
	t.belongs_to :user, index: true
	t.belongs_to :movie, index: true
    end
  end
end
