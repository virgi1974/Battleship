require 'player'

describe Player do
  let!(:player) { FactoryBot.build(:player) }
  let!(:player_without_name) { FactoryBot.build(:player, name: "") }

  describe 'initialization' do
    it 'has expected attributes' do
      expect(player.methods.include?(:name)).to be true
      expect(player.methods.include?(:board)).to be true
    end
  end
end