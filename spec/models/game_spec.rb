require 'game'
require 'player'

describe Game do
  let!(:player) { FactoryBot.build(:player) }
  let!(:player_without_name) { FactoryBot.build(:player, name: "") }
  let!(:game) { Game.new(player, player_without_name) }

  describe 'initialization' do
    it 'has expected attributes' do
      expect(game.methods.include?(:players)).to be true
      expect(game.players.is_a?(Array)).to be true
      expect(game.players).to eq [player, player_without_name]
    end
    
    it 'boards get assigned to players' do
      expect(game.players[0].board).to_not be nil
      expect(game.players[0].board).to_not be nil
    end
  end

  context 'methods' do
    describe '#create_ship' do
      it 'fails when positions not correct' do
        wrong_positions = [[:a0, :a1, :a100], 
                           [:a0, :a1, :a4], 
                           [:a0, :a1, :b2], 
                           [:a0, :a1]]
        ship_size = 3
        board = game.players[0].board
        expect(game.create_ship(board, wrong_positions.sample, ship_size)).to be false
        expect(board.ships).to be_empty
      end

      it 'succees when positions are correct' do
        good_positions = [[:a0, :a1, :a2], 
                          [:b0, :c0, :d0]]
        ship_size = 3
        board = game.players[0].board
        expect(game.create_ship(board, good_positions.sample, ship_size)).to be true
        expect(board.ships).to_not be_empty
      end
    end

    describe '#drop_bomb' do
      it 'fails when position not correct' do
        wrong_position = :a100
        board = game.players[0].board
        board.ships = [[:a0, :a1, :a3]]
        expect(game.drop_bomb(board, wrong_position)).to be false
        expect(board.ships).to eq [[:a0, :a1, :a3]]
      end

      it 'succees when position is correct' do
        good_position = :a1
        board = game.players[0].board
        board.ships = [[:a0, :a1, :a3]]
        expect(game.drop_bomb(board, good_position)).to_not be false
        expect(board.ships).to eq [[:a0, :a3]]
      end

      it 'return mapping by case if succees' do
        board = game.players[0].board
        board.ships = [[:a0, :a1]]
        expect(game.drop_bomb(board, :a1)).to eq 'Hit'
        expect(board.ships).to eq [[:a0]]
        expect(game.drop_bomb(board, :b3)).to eq 'Miss'
        expect(game.drop_bomb(board, :a0)).to eq 'Sink'
        expect(board.ships).to eq [[]]
      end
    end
    
    describe '#player_without_ships?' do
      it 'returns true when board has no ships' do
        board = game.players[0].board
        board.ships = [[]]
        expect(game.player_without_ships?(board)).to be true
      end
      
      it 'returns false when board has ships' do
        board = game.players[0].board
        board.ships = [[:a0]]
        expect(board.ships).to_not be_empty
        expect(game.player_without_ships?(board)).to be false
      end
    end
  end
end