require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt

  validates :email, presence: true
   validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  validates :password_hash, presence: true 


  # Remember to create a migration!
  has_many :rounds
  has_many :decks, :through => :rounds



  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end


 
end


