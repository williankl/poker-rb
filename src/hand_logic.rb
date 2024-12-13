require_relative "models/card"
require_relative "models/suit"

def get_high_cards(all_cards:, number_of_cards:)
  sorted_cards = all_cards.sort_by do |card|
    card.value
  end
  sorted_cards.last(number_of_cards)
end

def get_double_pairs(all_cards:)
  first_pair = get_repeating_cards(
    cards: all_cards,
    repeated_times: 2,
  )
  modified_cards = all_cards - first_pair
  second_pair = get_repeating_cards(
    cards: modified_cards,
    repeated_times: 2,
  )
  if first_pair.nil? || first_pair.empty? || second_pair.nil? || second_pair.empty?
    nil
  else
    first_pair + second_pair
  end
end

def get_pair(all_cards:)
  get_repeating_cards(
    cards: all_cards,
    repeated_times: 2,
  )
end

def get_three_of_a_kind(all_cards:)
  get_repeating_cards(
    cards: all_cards,
    repeated_times: 3,
  )
end

def get_four_of_a_kind(all_cards:)
  get_repeating_cards(
    cards: all_cards,
    repeated_times: 4,
  )
end

def get_straight(all_cards:)
  get_sequence(
    cards: all_cards,
    min_sequence_size: 5,
  )
end

def get_flush(all_cards:)
  same_suit_card_groups = group_cards_by_suits(all_cards: all_cards)
  same_suit_card_groups.find do |cards|
    cards.length >= 5
  end
end

def get_full_house(all_cards:)
  three_of_a_kind = get_repeating_cards(
    cards: all_cards,
    repeated_times: 3,
  )  
  pair = get_repeating_cards(
    cards: all_cards,
    repeated_times: 2,
  )
  if three_of_a_kind.nil? || three_of_a_kind.empty? || pair.nil? || pair.empty?
    return nil
  else
    return three_of_a_kind + pair
  end
end

def get_straight_flush(all_cards:)
  same_suit_card_groups = group_cards_by_suits(all_cards: all_cards)
  same_suit_card_groups.find do |cards|
    sequence = get_sequence(
      cards: cards,
      min_sequence_size: 5,
    )
    sequence != nil
  end
end

private def get_sequence(cards:, min_sequence_size:)
  sequence_list = []
  current_sequence = []
  last_card = nil
  cards.each_with_index do  |card, index|
    if last_card.nil? || card.value - last_card&.value == 1
      current_sequence << card
    else
      sequence_list << current_sequence
      current_sequence = [card]
    end
    last_card = card
  end
  sequence_list << current_sequence

  sequence_list.reverse.find do |cards|
    cards.length >= min_sequence_size
  end
end

private def group_cards_by_suits(all_cards:)
  Suits.entries.map do |suit|
    all_cards.select do |card|
      card.suit == suit
    end  
  end
end

private def get_repeating_cards(cards:, repeated_times:)
  cards.each do |card|
    cards_with_same_value = cards.select do |comparing_card|
      comparing_card.value == card.value
    end
    if cards_with_same_value.length == repeated_times
      return cards_with_same_value
    end
  end
  return nil
end