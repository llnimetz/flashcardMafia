require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt


  # Remember to create a migration!
  has_many :rounds
  has_many :decks, :through => :rounds



  def password
    @password ||= Password.new(:password)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    Self.password_hash = @password
  end


  def self.authenticate(params)


    @user = User.find_by_email(params[:email])
    @valid == false
    while @user
    if @user.password == params[:password] 
     @valid == true 
   else 
    false 
    end
  end
end
end




