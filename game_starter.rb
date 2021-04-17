# frozen_string_literal: true

require 'readline'
require './lib/game'
require './lib/player'

puts '############# press CTR-C to exit #############'

########## SETTING USERS BY NAME ##########
puts "please choose a name for the first player: \n"
prompt = '>  '
first_player_name = Readline.readline(prompt, true)

puts "please choose a name for the second player: \n"
prompt = '>  '
second_player_name = Readline.readline(prompt, true)

def init_game(first_player_name, second_player_name)
  names = [first_player_name, second_player_name]
  names.shuffle! if ARGV[0] == 'RANDOM'

  first_player = Player.new(names[0])
  second_player = Player.new(names[1])

  ########## INIT GAME ##########
  $current_game = Game.new(first_player, second_player)

  puts "############# THIS IS THE BOARD ############# \n"
  puts '               a0 a1 a2 a3 a4                   '
  puts '               b0 b1 b2 b3 b4                   '
  puts '               c0 c1 c2 c3 c4                   '
  puts '               d0 d1 d2 d3 d4                   '
  puts '               e0 e1 e2 e3 e4                   '

  ########## INIT SHIPS CREATION FOR EACH PLAYER ##########
  def select_ship_positions(player, ship_size)
    valid_selection = false
    while valid_selection == false
      puts "---- #{player.name} ---- please choose positions for the #{ship_size}x1 ship: \n"
      puts "must be separated by a space like: a0 a1 a3 \n"
      prompt = '>  '
      positions = Readline.readline(prompt, true)
      positions_simbolized = positions.split(' ').map(&:to_sym)

      valid_selection = $current_game.create_ship(player.board, positions_simbolized, ship_size)
      message = valid_selection == true ? "👍 Good Choice \n" : "👎 wrong positions , please try again \n"
      puts message
    end
  end

  # ship 3x1 4x1
  Game::SHIP_POSITIONS.each do |number_of_fields|
    select_ship_positions(first_player, number_of_fields)
    select_ship_positions(second_player, number_of_fields)
  end

  ########## GAME STARTS ##########

  def compose_message(message)
    case message
    when 'Hit'
      "#{message} 🚀"
    when 'Miss'
      "#{message} 🤦‍♂️"
    when 'Sink'
      "#{message} 🚣‍♂️"
    else
      'upppppsssss'
    end
  end

  def select_player_movement(player, target_player)
    valid_movement = false
    attempts = 0
    while valid_movement == false
      puts "#{player.name} - choose you movement  💣 \n"
      prompt = '>  '
      position = Readline.readline(prompt, true)

      valid_movement = $current_game.drop_bomb(target_player.board, position.to_sym)

      if valid_movement == false && attempts == 0
        attempts += 1
        puts "👎 wrong position but you have an extra shot! \n"
      elsif valid_movement == false
        puts "👎 wrong position again \n"
        break
      else
        message = compose_message(valid_movement)
      end
      puts message
    end
  end

  def has_all_ships_sank?(player)
    $current_game.player_without_ships?(player.board)
  end

  winner = false
  while winner == false
    # player 1 movement
    select_player_movement(first_player, second_player)
    if has_all_ships_sank?(second_player)
      winner = first_player
      break
    end

    # player 2 movement
    select_player_movement(second_player, first_player)
    if has_all_ships_sank?(first_player)
      winner = second_player
      break
    end
  end

  puts '👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️'
  puts "And the winner is .... #{winner.name}"
  puts "👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️👯‍♀️ \n"

  ########## PLAYING AGAIN ##########
  puts "######## Play again [P] ########\n"
  prompt = '>  '
  option = Readline.readline(prompt, true)
  init_game(first_player_name, second_player_name) if option.downcase == 'p'
end

init_game(first_player_name, second_player_name)
