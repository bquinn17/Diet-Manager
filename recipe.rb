#Recipe.rb
#represents an instance of a recipe object
class Recipe

  #Creats a new Recipe object with the given name
  #and list of BasicFoods. It also adds up all of
  #the calories in the given foods
  def initialize(name, foods, recipes=[])
    @name = name
    @foods = foods #represented as a list of BasicFood objects
    @recipes = recipes 
    @calories = total_calories
  end
  
  #Goes through all of the foods in the recipe
  #and adds up their calorie counts
  def total_calories
    calories = 0
    @foods.each do |food|
      calories += food.calories.to_i
    end
    @recipes.each do |food|
      calories += food.calories.to_i
    end
    return calories
  end

  #Prints all of the foods in the recipe with
  #the correct output style
  def print_foods(depth = 2) 
    ingredients = Hash.new
    @foods.each do |food|
      if ingredients.has_key? food
        ingredients[food][0] += 1
        ingredients[food][1] = (food.calories.to_i + ingredients[food][1].to_i).to_s
      else
        ingredients.store(food,[1,food.calories])
      end
    end
    ingredients.each_key do |ingredient|
      if ingredients[ingredient][0] < 2 
        depth.times{ |i|  print ' '}
        puts ingredient.name + ' ' + ingredient.calories
      else
        depth.times{ |i|  print ' '}
        puts ingredient.name + ' (' + ingredients[ingredient][0].to_s + ') ' + ingredients[ingredient][1]
      end
    end
    ingredients = Hash.new 
    @recipes.each do |recipe| 
      if ingredients.has_key? recipe
        ingredients[recipe][0] += 1
        ingredients[recipe][1] = (recipe.calories.to_i + ingredients[recipe][1].to_i).to_s
      else
        ingredients.store(recipe,[1,recipe.calories])
      end
    end
    ingredients.each_key do |ingredient|
      if ingredients[ingredient][0] < 2 
        depth.times{ |i| print ' ' }
        puts ingredient.name + ' ' + ingredient.calories.to_s
        depth += 2
        ingredient.print_foods(depth)
      else
        depth.times{ |i|  print ' '}
        puts ingredient.name + ' (' + ingredients[ingredient][0].to_s + ') ' + ingredients[ingredient][1]
        depth += 2
        ingredient.print_foods(depth)
      end  
    end
  end

  #makes these global variables accessable by other classes
  attr_reader :name, :calories, :foods, :recipes
end
