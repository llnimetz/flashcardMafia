get '/' do
  # Look in app/views/index.erb

  erb :index
end



post '/user/create' do

  User.create(params[:email, :password])

  redirect to "/home"
end


post '/user/login' do 
# Self.authenticate params

redirect to "/home"
end

get '/home' do 

  erb :home
end


get '/home/play' do

  erb :play
end


get '/home/history' do

  erb :history
end
