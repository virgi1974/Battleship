# frozen_string_literal: true

require 'faker'

class Player
  attr_accessor :name, :board

  def initialize(name)
    @name = name.empty? ? Faker::Movies::Lebowski.character : name
    @board = nil
  end
end
