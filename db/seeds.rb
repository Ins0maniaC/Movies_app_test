# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'open-uri'

@doc=Nokogiri::XML(open("http://www.kinoballada.info/repertuar/export/small/dzien/xml"))
movie_array = []
@doc.css('dzien').each do |node|
    children=node.children
    movie_array << children.css('tytul').inner_text
    Movie.find_or_create_by(
    :name => children.css('tytul').inner_text
    )
    end
    movies_to_delete = Movie.where.not(name: movie_array)
    movies_to_delete.destroy_all
