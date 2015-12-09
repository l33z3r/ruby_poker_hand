class Deck
  attr_accessor :cards
  SIZE = 52
  HAND_SIZE = 5

  def initialize
    self.cards = []

    Rank::RANKS.each do |rank|
      Suit::SUITS.each do |suit|
        next_card = Card.new(Rank.new(rank), Suit.new(suit))
        self.cards.push(next_card)
      end
    end
  end

  def deal
    Hand.new(self.cards.sample(5))
  end
end

class Suit
  HEARTS = 1
  CLUBS = 2
  DIAMONDS = 3
  SPADES = 4

  SUITS = [HEARTS, CLUBS, DIAMONDS, SPADES]

  DISPLAY_MAP = {
    HEARTS => 'Hearts',
    CLUBS => 'Clubs',
    DIAMONDS => 'Diamonds',
    SPADES => 'Spades'
  }

  attr_accessor :value

  def initialize(value)
    self.value = value
  end

  def to_s
    DISPLAY_MAP[self.value]
  end
end

class Rank
  TWO = 1
  THREE = 2
  FOUR = 3
  FIVE = 4
  SIX = 5
  SEVEN = 6
  EIGHT = 7
  NINE = 8
  TEN = 9
  JACK = 10
  QUEEN = 11
  KING = 12
  ACE = 13

  RANKS = [TWO, THREE, FOUR, FIVE, SIX, SEVEN,
           EIGHT, NINE, TEN, JACK, QUEEN, KING, ACE]

  DISPLAY_MAP = {
    TWO => '2',
    THREE => '3',
    FOUR => '4',
    FIVE => '5',
    SIX => '6',
    SEVEN => '7',
    EIGHT => '8',
    NINE => '9',
    TEN => '10',
    JACK => 'Jack',
    QUEEN => 'Queen',
    KING => 'King',
    ACE => 'Ace'
  }

  attr_accessor :value

  def initialize(value)
    self.value = value
  end

  def to_s
    DISPLAY_MAP[self.value]
  end
end

class Card
  attr_accessor :rank, :suit

  def initialize(rank, suit)
    self.rank = rank
    self.suit = suit
  end

  def to_s
    "#{rank} Of #{suit}"
  end
end

class Hand
  attr_accessor :cards

  def initialize(cards)
    self.cards = cards
    self.cards.sort! { |card1, card2| card1.rank.value <=> card2.rank.value }
  end

  def print
    self.cards.each do |card|
      puts card
    end
  end

  def show
    if straight_flush = check_straight_flush
      return 'Straight Flush', "To #{straight_flush.first.rank}"
    elsif poker = check_poker
      return 'Poker', poker.first.rank
    elsif full_house = check_full_house
      return 'Full House', "#{full_house[:trips].first.rank}'a And #{full_house[:first_pair].first.rank}'s'"
    elsif flush = check_flush
      return 'Flush', flush.first.suit
    elsif straight = check_straight
      return 'Straight', "To #{straight.last.rank}"
    elsif triples = check_triples
      return 'Triples', "#{triples.first.rank}'s"
    elsif two_pair = check_two_pair
      return 'Two Pair', "#{two_pair[:first_pair].first.rank}'s' And #{two_pair[:second_pair].first.rank}'s'"
    elsif pair = check_pair
      return 'Pair', "#{pair.first.rank}'s"
    else
      high_card = check_high_card
      return 'High Card', high_card.rank
    end
  end

  def set_flush_hand
    self.cards = [
        Card.new(Rank.new(Rank::TWO), Suit.new(Suit::HEARTS)),
        Card.new(Rank.new(Rank::THREE), Suit.new(Suit::HEARTS)),
        Card.new(Rank.new(Rank::FIVE), Suit.new(Suit::HEARTS)),
        Card.new(Rank.new(Rank::SIX), Suit.new(Suit::HEARTS)),
        Card.new(Rank.new(Rank::EIGHT), Suit.new(Suit::HEARTS))
    ]
  end

  def set_poker_hand
    self.cards = [
        Card.new(Rank.new(Rank::TWO), Suit.new(Suit::HEARTS)),
        Card.new(Rank.new(Rank::TWO), Suit.new(Suit::CLUBS)),
        Card.new(Rank.new(Rank::TWO), Suit.new(Suit::DIAMONDS)),
        Card.new(Rank.new(Rank::TWO), Suit.new(Suit::SPADES)),
        Card.new(Rank.new(Rank::FOUR), Suit.new(Suit::HEARTS))
    ]
  end

  def set_two_pair_hand
    self.cards = [
        Card.new(Rank.new(Rank::TWO), Suit.new(Suit::HEARTS)),
        Card.new(Rank.new(Rank::TWO), Suit.new(Suit::CLUBS)),
        Card.new(Rank.new(Rank::THREE), Suit.new(Suit::HEARTS)),
        Card.new(Rank.new(Rank::THREE), Suit.new(Suit::CLUBS)),
        Card.new(Rank.new(Rank::FOUR), Suit.new(Suit::HEARTS))
    ]
  end

  def set_pair_hand
    self.cards = [
        Card.new(Rank.new(Rank::TWO), Suit.new(Suit::HEARTS)),
        Card.new(Rank.new(Rank::TWO), Suit.new(Suit::CLUBS)),
        Card.new(Rank.new(Rank::THREE), Suit.new(Suit::HEARTS)),
        Card.new(Rank.new(Rank::SIX), Suit.new(Suit::CLUBS)),
        Card.new(Rank.new(Rank::FOUR), Suit.new(Suit::HEARTS))
    ]
  end

  def set_triples_hand
    self.cards = [
        Card.new(Rank.new(Rank::TWO), Suit.new(Suit::HEARTS)),
        Card.new(Rank.new(Rank::TWO), Suit.new(Suit::CLUBS)),
        Card.new(Rank.new(Rank::TWO), Suit.new(Suit::DIAMONDS)),
        Card.new(Rank.new(Rank::THREE), Suit.new(Suit::CLUBS)),
        Card.new(Rank.new(Rank::FOUR), Suit.new(Suit::HEARTS))
    ]
  end

  def set_flush_hand
    self.cards = [
        Card.new(Rank.new(Rank::TWO), Suit.new(Suit::HEARTS)),
        Card.new(Rank.new(Rank::THREE), Suit.new(Suit::HEARTS)),
        Card.new(Rank.new(Rank::FIVE), Suit.new(Suit::HEARTS)),
        Card.new(Rank.new(Rank::SIX), Suit.new(Suit::HEARTS)),
        Card.new(Rank.new(Rank::EIGHT), Suit.new(Suit::HEARTS))
    ]
  end

  def set_full_house_hand
    self.cards = [
        Card.new(Rank.new(Rank::TWO), Suit.new(Suit::HEARTS)),
        Card.new(Rank.new(Rank::TWO), Suit.new(Suit::CLUBS)),
        Card.new(Rank.new(Rank::FIVE), Suit.new(Suit::HEARTS)),
        Card.new(Rank.new(Rank::FIVE), Suit.new(Suit::CLUBS)),
        Card.new(Rank.new(Rank::FIVE), Suit.new(Suit::DIAMONDS))
    ]
  end

  def set_straight_hand
    self.cards = [
        Card.new(Rank.new(Rank::THREE), Suit.new(Suit::HEARTS)),
        Card.new(Rank.new(Rank::FOUR), Suit.new(Suit::HEARTS)),
        Card.new(Rank.new(Rank::FIVE), Suit.new(Suit::CLUBS)),
        Card.new(Rank.new(Rank::SIX), Suit.new(Suit::DIAMONDS)),
        Card.new(Rank.new(Rank::SEVEN), Suit.new(Suit::HEARTS)),
    ]
  end

  def set_straight_flush_hand
    self.cards = [
        Card.new(Rank.new(Rank::FOUR), Suit.new(Suit::HEARTS)),
        Card.new(Rank.new(Rank::FIVE), Suit.new(Suit::HEARTS)),
        Card.new(Rank.new(Rank::SIX), Suit.new(Suit::HEARTS)),
        Card.new(Rank.new(Rank::SEVEN), Suit.new(Suit::HEARTS)),
        Card.new(Rank.new(Rank::EIGHT), Suit.new(Suit::HEARTS))
    ]
  end

  def check_two_pair
    self.cards.reverse!

    first_pair = card_count(2)

    if first_pair
      temp_cards = self.cards.dup

      #remove the pair from the hand
      first_pair_ranks = first_pair.map { |card| card.rank.value }
      self.cards = self.cards.select { |card| !first_pair_ranks.include?(card.rank.value) }

      second_pair = card_count(2)

      self.cards = temp_cards

      self.cards.reverse!

      if second_pair
        return { first_pair: first_pair, second_pair: second_pair }
      else
        return nil
      end
    end
  end

  def check_pair
    card_count(2)
  end

  def check_triples
    card_count(3)
  end

  def check_straight_flush
    if check_flush && check_straight
      return self.cards
    else
      return nil
    end
  end

  def check_poker
    card_count(4)
  end

  def check_flush
    self.cards.each do |card1|
      selected_cards = self.cards.select { |card2| card1.suit.value == card2.suit.value }

      if selected_cards.count == 5
        return selected_cards
      end
    end

    return nil
  end

  def check_full_house
    first_pair = card_count(2)

    if first_pair
      temp_cards = self.cards.dup

      #remove the pair from the hand
      first_pair_ranks = first_pair.map{ |card| card.rank.value }
      self.cards = self.cards.select { |card| !first_pair_ranks.include?(card.rank.value) }

      trips = card_count(3)

      self.cards = temp_cards

      if trips
        return { first_pair: first_pair, trips: trips }
      else
        return nil
      end
    end
  end

  def check_straight
    # Ensure difference between each consecutive card is 1
    previous_rank = self.cards.first.rank.value

    self.cards.last(4).each do |card1|
      return nil if (card1.rank.value - previous_rank != 1)
      previous_rank = card1.rank.value
    end
  end

  def check_high_card
    self.cards.min { |card1, card2| card2.rank.value.to_i <=> card1.rank.value.to_i}
  end

  private

  def card_count(amount)
    self.cards.each do |card1|
      selected_cards = cards.select { |card2| card1.rank.value == card2.rank.value }

      if selected_cards.count == amount
        return selected_cards
      end
    end

    return nil
  end
end

d = Deck.new

hand = d.deal

# hand.set_straight_flush_hand
# hand.set_poker_hand
# hand.set_full_house_hand
# hand.set_flush_hand
# hand.set_straight_hand
# hand.set_triples_hand
# hand.set_two_pair_hand
# hand.set_pair_hand

hand.print

hand_type, hand_value = hand.show

puts "Found #{hand_type}: #{hand_value}"


