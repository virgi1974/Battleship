require './lib/board'

class Game
  attr_accessor :players

  RESULTS = { 0 => 'Miss', 1 => 'Hit', 2 => 'Sink' }
  SHIP_POSITIONS = [3,4]

  def initialize(player_1, player_2)
    @players = [player_1, player_2]
    assign_boards_to_players
  end

  def assign_boards_to_players
    players[0].board = Board.new
    players[1].board = Board.new
  end

  def create_ship(board, positions, ship_size)
    board.valid_self_positions_setup?(positions, ship_size) && 
    board.create_ship(positions)
  end

  def drop_bomb(target_board, position)
    valid_position = target_board.valid_adversary_positions_setup?([position], 1)
    return valid_position if valid_position == false
    
    result = target_board.drop_bomb(position)
    RESULTS[result]
  end

  def player_without_ships?(target_board)
    target_board.ships.flatten.empty?
  end

end