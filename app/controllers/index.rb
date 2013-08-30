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


post '/deck/:id' do
  round = Round.create(deck_id: params[:id], user_id: session[:user_id])
  redirect '/round' + round.id
end


get '/round/:id' do
  @round = Round.find(params[:id])
  @deck = Deck.find(@round.deck_id)
  @cards = shuffle_deck(@deck)
  if @cards.empty?
    erb :finished_round
  else
    @current_card = @cards.pop
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
