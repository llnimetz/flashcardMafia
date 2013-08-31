a = Deck.create(title: "State Capitols")
b = Deck.create(title: "Cohorts")

Card.create(question: "What is the capitol of California?", answer: "Sacramento", deck_id: a.id)
Card.create(question: "What is the capitol of Washington?", answer: "Olympia", deck_id: a.id)
Card.create(question: "What is the capitol of Nobody Cares?", answer: "Nobody Cares", deck_id: a.id)
Card.create(question: "What is the capitol of Nebraska?", answer: "Lincoln", deck_id: a.id)
Card.create(question: "Which cohort is named after a bird?", answer: "Purple Martins", deck_id: b.id)
Card.create(question: "Which cohort has the coolest members?", answer: "Mule Deer", deck_id: b.id)

c = User.new(email: "my@email.com")
c.password = "password"
c.save

Round.create(deck_id: a.id, user_id: c.id)
