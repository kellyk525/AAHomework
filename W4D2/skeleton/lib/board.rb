require_relative "player"

class Board
  attr_accessor :cups

  def initialize(name1, name2)
    @name1 = name1
    @name2 = name2
    @cups = Array.new(14) {Array.new}
    place_stones
  end

  def place_stones
    # helper method to #initialize every non-store cup with four stones each
    @cups.each_with_index do |cup, i|
      if i == 6 || i == 13
        @cups[i] = []
      else
        @cups[i] = [:stone, :stone, :stone, :stone]
      end
    end
    # @cups.each_with_index do |cup, idx|
    #   next if idx == 6 || idx == 13
    #   4.times do
    #     cup << :stone
    #   end
    # end

  end

  def valid_move?(start_pos)
    if start_pos == 0
      raise "Starting cup is empty"
    elsif start_pos > 12
      raise "Invalid starting cup"
    elsif @cups[start_pos].empty?
      raise "Starting cup is empty"
    end
  end

  def make_move(start_pos, current_player_name)
    stones = @cups[start_pos]
    @cups[start_pos] = []

    cup_i = start_pos
    until stones.empty?
      cup_i += 1
      cup_i = 0 if cup_i > 13
      if cup_i == 6
        @cups[6] << stones.pop if current_player_name == @name1
      elsif cup_i == 13
        @cups[13] << stones.pop if current_player_name == @name2
      else
        @cups[cup_i] << stones.pop
      end
    end

    self.render
    self.next_turn(cup_i)
  end 

  def next_turn(ending_cup_idx)
    # helper method to determine whether #make_move returns :switch, :prompt, or ending_cup_idx
    if ending_cup_idx == 6 || ending_cup_idx == 13
      :prompt
    elsif @cups[ending_cup_idx].length == 1
      :switch
    else
      ending_cup_idx
    end
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    @cups.take(6).all?(&:empty?) || @cups[7..12].all?(&:empty?)
    #take 6 would only take until index 5 && skip index 6!!
  end

  def winner
    return :draw if @cups[6].length == @cups[13].length
    if @cups[6].length > @cups[13].length
      return @name1
    else
      return @name2
    end
  end
end
