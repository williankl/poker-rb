class Card 
  attr_reader :value, :suit

  def initialize(value:, suit:)
    @value = value
    @suit = suit
  end

  def to_json(*_args)
    JSON.pretty_generate(
      {
        value: @value,
        suit: @suit,
      }
    )
  end
end