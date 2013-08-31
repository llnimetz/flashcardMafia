helpers do
  attr_accessor :cards

  def log_in(user_id)
    session[:user_id] = user_id
  end

  def log_out
    session[:user_id] = false
  end

  def logged_in?
    session[:user_id] != false
  end

  def return_user
    User.find(session[:user_id])
  end

  def confirm_password?(password, password_reconfirm)
    password == password_reconfirm
  end


  def shuffle_deck(deck)
    to_shuffle = deck.cards.dup
    cards = to_shuffle.shuffle!
    card_ids = []
    cards.each do |c|
      card_ids << c.id
    end
    card_ids
  end

  def set_current_card
    session[:cards].pop
  end

end
