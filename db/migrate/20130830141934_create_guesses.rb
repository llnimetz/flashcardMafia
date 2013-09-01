class CreateGuesses < ActiveRecord::Migration
  def change
    create_table :guesses do |t|
      t.belongs_to :round
      t.belongs_to :card
      t.boolean :result
      t.string :guess_input
      t.timestamps
    end
  end
end
