enable :session

get '/' do
  # Look in app/views/index.erb

  erb :index


end

post '/user/create' do

  @user = User.new(params[:email])
  @user.password = params[:password]
  @user.save!



  redirect to "/home"
end


post '/user/login' do 

User.authenticate params
p "-----"
p @valid
if @valid 
  erb :home

else erb :index
  end
end


get '/home' do 
  @deck = Deck.all

  erb :home
end


get '/home/play' do

  erb :play_card 
end


get '/home/history' do

  erb :history
end


post '/deck/:id' do
  round = Round.create(deck_id: params[:id], user_id: session[:user_id])
  @deck = Deck.find(round.deck_id)
  session[:cards] = shuffle_deck(@deck) 
  redirect "/round/#{round.id}"
end




get '/round/:id' do
  @round = Round.find(params[:id])
  @deck = Deck.find(@round.deck_id)
  if session[:cards].empty?
    erb :finished_round
  else
    @current_card = Card.find(set_current_card)
    erb :play_card
  end
end

post '/card/:id/:round_id' do
  @current_card = Card.find(params[:id])
  @round = Round.find(params[:round_id])
  @guess = Guess.new(round_id: @round.id, guess_input: params["guess_input"]) 
  if @current_card.answer == @guess.guess_input
    @guess.result = true
  else
    @guess.result = false
  end
  
  @guess.save
  redirect "/round/guess/#{@guess.id}/#{@current_card.id}"
end

get '/round/guess/:guess_id/:card_id' do
  @guess = Guess.find(params[:guess_id])
  @round = Round.find(@guess.round_id)
  @current_card = Card.find(params[:card_id])
  if @guess.result == true
    erb :result_page_correct
  else
    erb :result_page_incorrect
  end
end
