require 'rspec'
require 'dessert'

=begin
Instructions: implement all of the pending specs (the `it` statements without blocks)! Be sure to look over the solutions when you're done.
=end

describe Dessert do
  let(:chef) { double("chef", name: "Kelly") }
  let(:dessert) {Dessert.new("cookie", 20, chef)}

  describe "#initialize" do
    it "sets a type" do 
      expect(dessert.type).to eq("cookie")
    end

    it "sets a quantity" do
      expect(dessert.quantity).to eq(20)
    end

    it "starts ingredients as an empty array" do
      expect(dessert.ingredients).to be_empty
    end

    it "raises an argument error when given a non-integer quantity" do
      expect {Dessert.new("cookie", "hello", "Kelly")}.to raise_error(ArgumentError)
    end
  end

  describe "#add_ingredient" do
    it "adds an ingredient to the ingredients array" do
      dessert.add_ingredient("chocolate")
      expect(dessert.ingredients).to include("chocolate")
    end
  end

  describe "#mix!" do
    it "shuffles the ingredient array" do
      dessert.mix!
      expect(dessert.ingredients).to eq(dessert.ingredients.shuffle!)
    end

    ingredients = ["chocolate", "flour", "egg", "sugar", "butter"]

    # ingredients.each do |ingredient|
    #   brownie.add_ingredient(ingredient)
    # end

    # expect(brownie.ingredients).to eq(ingredients)
    # brownie.mix!
    # expect(brownie.ingredients).not_to eq(ingredients)
    # expect(brownie.ingredients.sort).to eq(ingredients.sort)
  
  end

  describe "#eat" do
    it "subtracts an amount from the quantity" do
      dessert.eat(10)
      expect(dessert.quantity).to eq(10)
    end

    it "raises an error if the amount is greater than the quantity" do
      expect{dessert.eat(23)}.to raise_error("not enough left!")
    end
  end

  describe "#serve" do
    it "contains the titleized version of the chef's name" do
      allow(chef).to receive(:titleize).and_return("Chef Kelly the Great Baker")
      expect(dessert.serve).to eq("Chef Kelly the Great Baker has made 20 cookies!")
    end
  end

  describe "#make_more" do
    it "calls bake on the dessert's chef with the dessert passed in" do
      allow(chef).to receive(:bake).with(dessert)
      dessert.make_more
    end
  end
end
