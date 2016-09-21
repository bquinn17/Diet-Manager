#BasicFood.rb
#Represents a basic food object
class BasicFood

  #Creates a new basic food object with the
  #given name and calorie count
  def initialize(name,calories)
    @name = name
    @calories = calories
  end

  #makes these global variables accessable by other classes
  attr_reader :name, :calories 

end
