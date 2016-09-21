#Food Database Manager
#Reprents the working database for the program
#handles user commmands, redirects
#data and controls output

require_relative 'BasicFood'
require_relative 'Recipe'

class FoodDB

  #initializes the working database by creating the arrays,
  #loading the database file, and handing over control to
  #the main method
  def initialize
    @foods = []
    @recipes = []
    loadDB
    @food_entries = @foods.length 
    @recipe_entries = @recipes.length #number of foods in the database 
  end

  attr_reader :foods, :recipes

  #saves any new food entries in the working database to FoodDB.txt
  def save 
    file = File.open('FoodDB.txt','a')
    if @foods.length > @food_entries
      new_entries = @foods.drop(@food_entries)
      new_entries.each do |entry|
        file.puts "#{entry.name},b,#{entry.calories}\n"
      end
    @food_entries = @foods.length
    end
    if @recipes.length > @recipe_entries
      new_entries = @recipes.drop(@recipe_entries) 
      new_entries.each do |entry|
        str = entry.name << ',r'
        entry.foods.each {|food| str << ',' << food.name }
        entry.recipes.each {|recipe| str << ',' << recipe.name }
        file.puts "#{str}\n"
      end
    @recipe_entries = @recipes.length
    end
    file.close 
  end

  #preforms functionality for new commands
  def create_food(last)
    if last.start_with? 'food'
      last.gsub!('food', '').strip!
      params = last.split(',')
      if not @foods.inject(false){|contains, food| contains or food.name.eql? params[0]}
        @foods.push(BasicFood.new(params[0],params[1])) #creats basic food and adds it
      else
        puts 'That food is already in the database!'
      end
    elsif last.start_with? 'recipe'
      last.gsub!('recipe', '').strip!
      params = last.split(',')
      if not @recipes.inject(false){|contains, food| contains or food.name.eql? params[0]}
        recipe_foods = []
        recipe_recipes = []
        params[1..(params.length-1)].each do |foodName|
          @recipes.each do |recipe|
            if recipe.name.eql? foodName 
              recipe_recipes.push(recipe)
            end
          end
          @foods.each do |food|
            if food.name.eql? foodName
              recipe_foods.push(food)
            end
          end
        end
        recipe_recipes.compact!
        recipe_foods.compact!
        puts "foods: #{recipe_foods.length}, recipes: #{recipe_recipes.length}, params: #{params.length}"
        if (recipe_foods.length + recipe_recipes.length) < params.length - 1
           puts 'Not all of those foods are in the database!'
        else  
          @recipes.push(Recipe.new(params[0],recipe_foods,recipe_recipes)) #creats recipe and adds it
        end
      else
        puts 'That recipe is already in the database!'
      end
    end
  end

  #preforms functionality for find command
  def find_foods(last)
    pattern = last.downcase
    @recipes.each do |recipe|
      if recipe.name.downcase.start_with? pattern
        print_recipe(recipe.name)
      end
    end
    @foods.each do |food|
      if food.name.downcase.start_with? pattern
        print_food(food.name)
      end
    end
  end

  #prints a specific recipe. If no recipe is specified, it prints 
  #all of the recipes in the working database
  def print_recipe(name = 'all')
    if name.eql? 'all'
      @recipes.each do |recipe|
        puts recipe.name + ' ' + recipe.calories.to_s
        recipe.print_foods
      end
    else
      @recipes.each do |recipe|
        if recipe.name.eql? name
          puts recipe.name + ' ' + recipe.calories.to_s
          recipe.print_foods
        end
      end
    end
  end

  #prints a specific food. If no food is specified, it prints 
  #all of the foods in the working database
  def print_food(name = 'all')
    if name.eql? 'all'
      @foods.each {|food| puts food.name + ' ' + food.calories}
    else
      @foods.each do |food|
        if food.name.eql? name
          puts food.name + ' ' + food.calories
        end
      end
    end
  end
 
  #loads BasicFoods and Recipes from the text file database
  #into the internal food database
  def loadDB(filename = 'FoodDB.txt')
    file = File.open(filename,'r')
    file.each do |entry|
      vars = entry.strip.split(',')
      if vars.length > 2
        case vars[1]
        when 'b' 
          @foods.push(BasicFood.new(vars[0],vars[2])) #creats basic food and adds it
        when 'r'
          recipe_foods = []
          recipe_recipes = []
          vars[2..(vars.length-1)].each do |foodName | 
            @foods.each do |food| 
              if food.name.eql? foodName
                recipe_foods.push(food)
              end
            end
            @recipes.each do |recipe| 
              if recipe.name.eql? foodName 
                recipe_recipes.push(recipe)
              end
            end
          end
          recipe_recipes.compact!
          recipe_foods.compact!  
          @recipes.push(Recipe.new(vars[0],recipe_foods,recipe_recipes)) #creats recipe and adds it
        else
        end
      end
    end
    file.close
  end 

end
