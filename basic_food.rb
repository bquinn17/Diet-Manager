class BasicFood
  def initialize(name,calories)
    @name = name
    @calories = calories
  end

  attr_reader :name, :calories
end