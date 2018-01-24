require "rails_helper"

module RequestsHelper
  def self.prepare_requests
    # Usuwamy wszystkie obiekty, klasa po klasie
    User.all.destroy_all
    Movie.all.destroy_all
    Topic.all.destroy_all
    Post.all.destroy_all

    # Tworzymy nowego usera, zapisujemy go i uzyskujemy token
    user = User.new(
      index: "123456",
      name:"Zenon",
      password: "haslo123"
    )
    user.save!
    user.regenerate_token
    user.reload

    # Tworzymy i zapisujemy w bazie nowy film
    movie = Movie.new(
      name: "Nazwa filmu",
    )
    movie.save!

    # Tworzymy i zapisujemy w bazie nowy temat
    topic = Topic.new(
      movie: movie,
      user: user,
      title: 'Tytuł tematu'
    )
    topic.save!

    # Tworzymy i zapisujemy w bazie nowy post
    post = Post.new(
      topic: topic,
      user: user,
      body: 'Przykładowy post'
    )
    post.save!

    # Zwracamy słownik z utworzonymi obiektami
    return {
      user: user,
      movie: movie,
      topic: topic,
      post: post
    }
  end
end
