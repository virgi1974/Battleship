# frozen_string_literal: true

require './lib/validators/position_validator'

class Board
  class OverWritingError < StandardError; end
  class OutOfBoardLimitsError < StandardError; end

  attr_accessor :fields, :size, :ships

  def initialize(size = 5)
    @size = size
    @fields = populate_board
    @ships = []
  end

  def populate_board
    positions = []
    ('a'..'z').to_a[0...size].each do |field_letter|
      size.times do |field_number|
        positions << "#{field_letter}#{field_number}".to_sym
      end
    end

    Hash[positions.collect { |position| [position, 0] }]
  end

  def letter_fields_configured_in_board
    ('a'..'z').to_a[0...size]
  end

  def create_ship(positions)
    positions.map do |candidate_position|
      if !fields.key?(candidate_position)
        raise OutOfBoardLimitsError, 'field is out of board limits'
      elsif fields[candidate_position] != 0
        raise OverWritingError, 'that field has been already updated'
      else
        fields[candidate_position] = 1
      end
    end

    ships << positions

    true
  end

  def valid_self_positions_setup?(positions, expected_number)
    PositionValidator.new(self, positions, expected_number).validate_self_board
  end

  def valid_adversary_positions_setup?(positions, expected_number)
    PositionValidator.new(self, positions, expected_number).validate_adversary_board
  end

  def drop_bomb(position)
    bombed = 0

    ships.each do |ship|
      if ship.include?(position)
        ship.delete(position)
        bombed = ship.empty? ? 2 : 1
      end
    end

    bombed
  end
end
