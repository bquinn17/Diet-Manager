#Starts the program by calling initialize in FoodDB.rb
require_relative 'FoodDB'
require_relative 'Log'

food = FoodDB.new
log = Log.new

#Main controller for the program. Reads in user input
#from the command line and takes appropriate action
$stdin.each do |line|
  puts ' '
  words = line.strip!.split(' ')
  first = words[0]
  words.delete_at(0)
  last = words.inject(''){|name, word| name << ' ' << word }
  last.strip!

  case first
  when 'quit'
    break
  when 'save'
    food.save
    log.save
  when 'new'
    food.create_food(last)
  when 'print'
    if not last.eql? 'all'
      if food.recipes.inject(false){|contains, recipe| contains or recipe.name.eql? last}
        food.print_recipe(last)
      elsif food.foods.inject(false){|contains, food| contains or food.name.eql? last}
        food.print_food(last)
      else
        puts 'There is no such food in the database'
      end
    else
      food.print_food
      puts ' '
      food.print_recipe
    end
  when 'find'
    food.find_foods(last)
  when 'log'
    params = last.split(',')
    if params.length < 2
      isfood = food.foods.inject(false){|contains, food| contains or params[0].eql? food.name}
      isrecipe = food.recipes.inject(false){|contains, recipe| contains or params[0].eql? recipe.name}
      if isfood or isrecipe
        log.new_log(params[0])
      else
        puts 'That food does not exist'
      end
    else
      isfood = food.foods.inject(false){|contains, food| contains or params[1].eql? food.name}
      isrecipe = food.recipes.inject(false){|contains, recipe| contains or params[1].eql? recipe.name}
      if isfood or isrecipe
        log.new_log(params[0],params[1])
      else
        puts 'That food does not exist'
      end
    end
  when 'show'
    if last.length < 1
      log.show
    elsif last.eql? 'all'
      log.show_all
    else
      log.show(last)
    end
  when 'delete'
    log.delete(last)
  else
    puts 'Enter a valid command'
  end
  puts ' '
end
log.save
food.save
