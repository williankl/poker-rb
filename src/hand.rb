require "json"

require_relative "models/card"
require_relative "models/power"
require_relative "models/suit"
require_relative "hand_logic"

class Hand 
  attr_reader :cards, :state, :winning_hand

  def initialize()
    @cards = []
    @state = Power::HighCard
    @winning_hand = []
  end

  def append_to_hand(card:)
    if @cards.length < 2
      @cards << card
    else
      puts("Hand is full, card cannot be added".red)
    end
  end

  def to_json(*_args)
    JSON.pretty_generate(
      {
        state: @state,
        cards: @cards,
        winning_hand: @winning_hand, 
      }
    )
  end

  def refresh_hand_state(table_cards:)
    all_cards = table_cards + self.cards
    case
    when !get_straight_flush(all_cards: all_cards).nil?
      @state = Power::StraightFlush
      @winning_hand = get_straight_flush(all_cards: all_cards)
    
    when !get_full_house(all_cards: all_cards).nil?
      @state = Power::FullHouse
      @winning_hand = get_full_house(all_cards: all_cards)
    
    when !get_flush(all_cards: all_cards).nil?
      @state = Power::Flush
      @winning_hand = get_flush(all_cards: all_cards)
    
    when !get_straight(all_cards: all_cards).nil?
      @state = Power::Straight
      @winning_hand = get_straight(all_cards: all_cards)
    
    when !get_four_of_a_kind(all_cards: all_cards).nil?
      @state = Power::FourOfAKind
      @winning_hand = get_four_of_a_kind(all_cards: all_cards)

    when !get_double_pairs(all_cards: all_cards).nil?
      @state = Power::DoublePairs
      @winning_hand = get_double_pairs(all_cards: all_cards)
    
    when !get_three_of_a_kind(all_cards: all_cards).nil?
      @state = Power::ThreeOfAKind
      @winning_hand = get_three_of_a_kind(all_cards: all_cards)

    when !get_pair(all_cards: all_cards).nil?
      @state = Power::Pair
      @winning_hand = get_pair(all_cards: all_cards)
    else
      @state = Power::HighCard
      @winning_hand = get_high_cards(
        all_cards: all_cards,
        number_of_cards: 5,
      )
    end

    if self.winning_hand.length < 5
      @winning_hand = self.winning_hand + get_high_cards(
        all_cards: all_cards - self.winning_hand,
        number_of_cards: 5 - self.winning_hand.length,
      )
    end
  end  
end