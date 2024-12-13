require "colorize"
require "debug"
require "progress_bar"
require "json"

require_relative "hand_logic"
require_relative "deck"
require_relative "hand"

begin
  deck = get_card_deck()
  table = []
  hand = Hand.new()
  2.times do |index|
    random_card = deck.sample
    deck.delete_at(deck.index(random_card))
    hand.append_to_hand(card: random_card)
  end
  5.times do |index|
    random_card = deck.sample
    deck.delete_at(deck.index(random_card))
    table << random_card
  end

  hand.refresh_hand_state(table_cards: table)
  puts(JSON.pretty_generate(hand))
end