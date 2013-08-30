class Card < ActiveRecord::Base
  # Remember to create a migration!
  has_one :deck

end
