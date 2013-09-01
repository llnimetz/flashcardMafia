enable :session

get '/' do
  if logged_in?
    redirect to '/home'
  else
    erb :index
  end

end

post '/user/create' do

  if confirm_password?(params[:password], params[:password_reconfirm]) 
    new_user = User.new(email: params[:email]) 
    new_user.password = params[:password]  
      if new_user.save
        redirect to "/home"
      else 
        @broadcast = new_user.errors.messages
        erb :index
      end
  else 
    @email = params[:email]
    @failed_login_message = "Passwords do not match. Please try again!"

    erb :index
  end

  
end


post '/user/login' do 

 @user = User.find_by_email(params[:email])
    if @user.password == params[:password]
      session[:user_id] = @user.id
      redirect '/home'
    else

      redirect to '/'
    end

end


get '/home' do 
  login_control
  @deck = Deck.all

  erb :home
end


get '/home/play' do
  login_control
  erb :play_card 
end


get '/home/history' do
  login_control
  erb :history
end

get '/logout' do
  log_out
  redirect to '/'
end


post '/deck/:id' do
  log_out
  round = Round.create(deck_id: params[:id], user_id: session[:user_id])
  @deck = Deck.find(round.deck_id)
  session[:cards] = shuffle_deck(@deck) 
  redirect "/round/#{round.id}/"
end

get '/round/stats/:id' do
  log_out
  @round = Round.find(params[:id])
  @stats = @round.guesses


  erb :round_stats
end


get '/round/:id/:guess_id?' do
  log_out
  @round = Round.find(params[:id])
  @deck = Deck.find(@round.deck_id)

  if params[:guess_id]
    @guess = Guess.find(params[:guess_id])
    if @guess.result == true
      @result = erb :result_page_correct, :layout => false
    else
      @result = erb :result_page_incorrect, :layout => false
    end
  end

  if session[:cards].empty?
    @stats = @round.guesses
    @correct = 0
    @incorrect = 0
    @stats.each do |s|
      if s.result == true
        @correct += 1
      else 
        @incorrect += 1
      end
    end
    erb :finished_round
  else
    @current_card = Card.find(set_current_card)
    erb :play_card
  end

end


post '/card/:id/:round_id' do
  log_out
  @current_card = Card.find(params[:id])
  @round = Round.find(params[:round_id])
  @guess = Guess.new(round_id: @round.id, guess_input: params["guess_input"]) 
  
  if @current_card.answer.downcase == @guess.guess_input.downcase
    @guess.result = true
  else
    @guess.result = false
  end
  
  @guess.save
  redirect "/round/#{@round.id}/#{@guess.id}"
end
