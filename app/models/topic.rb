class Topic < ApplicationRecord
  belongs_to :user
  belongs_to :movie
  has_many :posts
end
