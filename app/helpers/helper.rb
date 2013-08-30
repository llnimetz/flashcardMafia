helpers do

def shuffle_deck(deck)
  to_shuffle = deck.cards.dup
  to_shuffle.shuffle!
end

end
