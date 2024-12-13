def get_card_deck()
  numbers_of_cards = 13
  deck = Suits.entries.map do |suit|
    list = []
    numbers_of_cards.times do |index|
      list << Card.new(
        value: index,
        suit: suit,
      )
    end
    list
  end
  return deck.flatten
end