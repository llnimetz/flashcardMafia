enable :session
require 'csv'

########### User login, creation, validatio #############


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
        session[:user_id] = new_user.id
        redirect to "/home"
      else 
        @broadcast = new_user.errors.messages
        erb :index
      end
  else 
    @email = params[:email]
    @failed_password = "Passwords do not match. Please try again!"

    erb :index
  end
end


post '/user/login' do 
  @user = User.find_by_email(params[:email])
  if @user.nil? 
    @failed_login_message = "Cannot recognize email or password. Please try again"
    erb :index
  else 
    if @user.password == params[:password]
      session[:user_id] = @user.id
      redirect '/home'
    else
      redirect to '/'
    end
  end
end

########### User homepages #############


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

########### Round creation and game logic #############


post '/deck/:id' do
  login_control
  round = Round.create(deck_id: params[:id], user_id: session[:user_id])
  @deck = Deck.find(round.deck_id)
  session[:cards] = shuffle_deck(@deck) 
  redirect "/round/#{round.id}/"
end


get '/round/stats/:id' do
  login_control
  @round = Round.find(params[:id])
  @stats = @round.guesses

  erb :round_stats
end


get '/round/:id/:guess_id?' do
  login_control
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
  login_control
  @current_card = Card.find(params[:id])
  @round = Round.find(params[:round_id])
  @guess = Guess.new(round_id: @round.id, card_id: @current_card.id, guess_input: params["guess_input"]) 
  
  if @current_card.answer.downcase == @guess.guess_input.downcase
    @guess.result = true
  else
    @guess.result = false
  end
  
  @guess.save
  redirect "/round/#{@round.id}/#{@guess.id}"
end

########### Deck Creation form and logic #############


get '/create_deck' do
  #deck creation form
  erb :create_deck
end


post '/create_deck' do
  #deck creation
  new_deck = Deck.create(title: params[:title])
  new_deck.cards << Card.create(question: params[:question], answer: params[:answer])
  new_deck.cards << Card.create(question: params[:question2], answer: params[:answer2])
  new_deck.cards << Card.create(question: params[:question3], answer: params[:answer3])
  redirect to '/'
end
