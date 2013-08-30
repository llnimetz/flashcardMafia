class Round < ActiveRecord::Base
  # Remember to create a migration!
  has_many :guesses
  belongs_to :user
  belongs_to :deck
end
