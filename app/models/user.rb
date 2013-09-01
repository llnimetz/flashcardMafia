require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt
  validates :password_hash, :presence =>  { :message => "Password required" }
  validates :password_hash, length: { minimum: 2,
            :message => "Password required" }
  validates :email, :presence => { :message => "Email required" }
  validates :email, :uniqueness => { :message => "Sorry that email is already in use" }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
            :message => "Please enter a valid email" }          
 



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


