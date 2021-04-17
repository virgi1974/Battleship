class PositionValidator
  attr_reader :board, :selection, :expected_number

  def initialize(board, selection, expected_number)
    @board = board 
    @selection = selection
    @expected_number = expected_number
  end
  
  def validate_self_board
    fields_exist_in_board? &&
    correct_number_of_fields? &&
    correct_order_in_selection? &&
    selection_available?
  end

  def validate_adversary_board
    fields_exist_in_board?
  end

  private

  def fields_exist_in_board?
    (selection - board.fields.keys).empty?
  end
  
  def correct_number_of_fields?
    selection.size == expected_number
  end
  
  def correct_order_in_selection?
    valid_horizontal? || valid_vertical?
  end

  def selection_available?
    selection.map do |candidate_position|
      return false if board.fields[candidate_position] != 0
    end

    true
  end
  
  def valid_horizontal?
    horizontal? && horizontal_consecutive?
  end
  
  def horizontal?
    selection.map{ |position| position[0] }
             .uniq
             .size == 1
  end

  def horizontal_consecutive?
    positions = selection.map{ |position| position[1].to_i }.sort
    positions.each_cons(2).all? { |x,y| y == x + 1 }
  end

  def valid_vertical?
    vertical? && vertical_consecutive?
  end

  def vertical?
    selection.map{ |position| position[1] }
             .uniq
             .size == 1
  end

  def vertical_consecutive?
    chosen_letters = selection.map{ |position| position[0] }
                              .sort
                              .join

    board.letter_fields_configured_in_board.join
                                     .include?(chosen_letters)
  end
end