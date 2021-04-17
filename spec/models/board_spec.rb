require 'board'
require 'pry'

describe Board do
  let!(:board) { FactoryBot.build(:board) }

  let(:expected_default_initialized_fields) {
    { :a0=>0, :a1=>0, :a2=>0, :a3=>0, :a4=>0,
      :b0=>0, :b1=>0, :b2=>0, :b3=>0, :b4=>0,
      :c0=>0, :c1=>0, :c2=>0, :c3=>0, :c4=>0,
      :d0=>0, :d1=>0, :d2=>0, :d3=>0, :d4=>0,
      :e0=>0, :e1=>0, :e2=>0, :e3=>0,:e4=>0 }
  }

  describe 'initialization' do
    it 'has expected attributes' do
      expect(board.methods.include?(:size)).to be true
      expect(board.size.is_a?(Integer)).to be true
      expect(board.methods.include?(:fields)).to be true
      expect(board.fields.is_a?(Hash)).to be true
      expect(board.methods.include?(:ships)).to be true
      expect(board.ships.is_a?(Array)).to be true
    end

    it 'creates default content' do
      expect(board.size).to eq 5
      expect(board.fields.size).to eq board.size*board.size
      expect(board.fields.values.uniq).to eq [0]
      [:a0, :b4, :c3, :d1, :e4].each do |expected_key|
        expect(board.fields.keys.include?(expected_key)).to be true
      end
      [:a5, :b100, :f0, :e5].each do |expected_key|
        expect(board.fields.keys.include?(expected_key)).to be false
      end
    end
    
  end
  

  context 'methods' do
    describe '#populate_board' do
      it 'returns default board fields' do
        expect(board.populate_board).to eq expected_default_initialized_fields
      end

      it 'size of created hash depends on size atribute' do
        board.size = 8
        created_hash = board.populate_board
        expect(created_hash.size).to eq 8*8
      end
    end

    describe '#letter_fields_configured_in_board' do
      it 'returns the letters to be used in fields attr' do
        default_letters = ["a", "b", "c", "d", "e"]
        expect(board.letter_fields_configured_in_board).to eq default_letters
        board.size = 6
        expect(board.letter_fields_configured_in_board).to eq default_letters << "f"
      end

      it 'size proportional to the board size attr' do
        expect(board.size).to eq 5
        expect(board.letter_fields_configured_in_board.size).to eq board.size
        board.size = 6
        expect(board.letter_fields_configured_in_board.size).to eq board.size
        expect(board.size).to eq 6
      end
    end

    describe '#create_ship' do
      # create_ship(positions)
      it 'updates the board values for the given positions' do
        candidate_positions = [:a0, :a1, :a3]
        # before has default values
        candidate_positions.each do |position|
          expect(board.fields[position]).to eq 0
        end
        expect(board.ships).to be_empty

        board.create_ship(candidate_positions)

        # after has new values
        candidate_positions.each do |position|
          expect(board.fields[position]).to eq 1
        end
        expect(board.ships).to_not be_empty
      end

      it 'returns true' do
        expect(board.create_ship([:a0, :a1, :a3])).to be true
      end

      it 'raises OverWritingError exception in case it tries to write more than once' do
        board.fields[:a0] = 1
        expect(board.fields[:a0]).to eq 1
        expect { board.create_ship([:a0, :a1, :a3]) }.to raise_error(Board::OverWritingError, 'that field has been already updated')
      end

      it 'raises OverWritingError exception in case it tries to write more than once' do
        expect(board.fields.key?(:a10)).to be false
        expect { board.create_ship([:a0, :a1, :a10]) }.to raise_error(Board::OutOfBoardLimitsError, 'field is out of board limits')
      end
    end

    describe '#drop_bomb' do
      it 'returns 0 1 2 integer values on case result' do
        board.ships << [:a1, :a2, :a3]
        # missing
        expect(board.drop_bomb(:a4)).to eq 0
        # hitting
        expect(board.drop_bomb(:a1)).to eq 1
        # sinking
        board.ships = [[:a1]]
        expect(board.drop_bomb(:a1)).to eq 2
      end
    end
  end
end