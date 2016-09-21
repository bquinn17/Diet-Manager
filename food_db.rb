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
    main
  end

  attr_reader :foods, :recipes

  #Main controller for the program. Reads in user input
  #from the command line and takes appropriate action
  def main
    $stdin.each do |line|
      words = line.strip!.split(' ')
      first = words[0]
      words.delete_at(0)
      last = words.inject(''){|name, word| name << ' ' << word }
      last.strip!
      case first
        when 'quit'
          break
        when 'save'
          save
        when 'new'
          create_food(last)
        when 'find'
          find_foods(last)
        when 'print'
          if not last.eql? 'all'
            if @recipes.inject(false){|contains, recipe| contains or recipe.name.eql? last}
              print_recipe(last)
            elsif @foods.inject(false){|contains, food| contains or food.name.eql? last}
              print_food(last)
            else
              puts 'There is no such food in the database'
            end
          else
            print_recipe
            print_food
          end
        else
          puts 'Enter a valid command'
      end
    end
    save
  end

  #saves any new food entries in the working database to FoodDB.txt
  def save
    file = File.open('FoodDB.txt','w')
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
      @foods.push(BasicFood.new(params[0],params[1])) #creats basic food and adds it
    elsif last.start_with? 'recipe'
      last.gsub!('recipe', '').strip!
      params = last.split(',')
      recipe_foods = Array.new(params.length-2)
      params[1..(params.length-1)].each do |foodName |
        @foods.each do |food|
          if food.name.eql? foodName
            recipe_foods.push(food)
          end
        end
      end
      recipe_foods.compact!
      @recipes.push(Recipe.new(params[0],recipe_foods)) #creats recipe and adds it
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
            recipe_foods = Array.new(vars.length-2)
            vars[2..(vars.length-1)].each do |foodName |
              @foods.each do |food|
                if food.name.eql? foodName
                  recipe_foods.push(food)
                end
              end
            end
            recipe_foods.compact!
            @recipes.push(Recipe.new(vars[0],recipe_foods)) #creats recipe and adds it
          else
        end
      end
    end
    file.close
  end

end
