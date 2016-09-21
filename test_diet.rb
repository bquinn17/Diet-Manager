require 'test/unit'
require './BasicFood'
require './Recipe'
require './LogItem'

class TestBasicFood < Test::Unit::TestCase
  def setup
    @foods = []
    @foods.push(BasicFood.new('Avocado', 225))
  end

  # def teardown
  # end

  def test_basic_food
    food = BasicFood.new('Avocado', 225)
    @foods.push(food)
    assert( food.calories == 225, 'Failure in BasicFood calorie accessor' )
    assert( food.name == 'Avocado', 'Failure in BasicFood name accessor' )
    assert( food.name == 'wrongname', 'This test should fail because the food.name is: ' + food.name )
  end

 def test_recipe 
    recipe = Recipe.new('Guacamole', @foods)

    assert( recipe.calories == 225, 'Failure in Recipe calorie accessor' )
    assert( recipe.name == 'Guacamole', 'Failure Recipe name accessor' )
    assert( recipe.name == 'wrongname', 'This test should fail because the recipe.name is: ' + recipe.name )
  end

def test_log_item
    item = LogItem.new('4/15/2024','PB&J Sandwich')

    assert( item.date == '4/15/2024' , 'Failure in LogItem date accessor' )
    assert( item.name == 'PB&J Sandwich', 'Failure LogItem name accessor' )
    assert( item.name == 'wrongname', 'This test should fail because the item.name is: ' + item.name )
  end

end
