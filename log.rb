require_relative 'LogItem'
require_relative 'FoodDB'

#Represents the working log database
class Log

  #initializes the working database by creating the arrays,
  #loading the database file, and handing over control to
  #the main method
  def initialize
    @log = []
    loadDB
  end

  #loads log items from the text file database
  #into the internal log database
  def loadDB(filename = 'DietLog.txt')
    file = File.open(filename,'r')
    file.each do |entry| 
      vars = entry.strip.split(',')
      if vars.length > 1 
        @log.push(LogItem.new(vars[0],vars[1])) #creats log item and adds it
      end 
    end
    file.close
    @log.compact!
  end

  #Saves the working database to the database file
  def save
    file = File.open('DietLog.txt', 'w') #refreshes the database each time
    @log.each do |entry|
      file.puts "#{entry.date},#{entry.name}"
    end
    file.close
  end

  #creates a new log entry with the default date of the current date
  def new_log(date=Time.now.strftime("%d/%m/%Y"),name)
    @log.push(LogItem.new(date,name))
  end

  #Prints all of the entries in the working database to stdout
  def show_all 
    @log.sort! do |first,second| 
      f_nums = first.date.split('/') 
      s_nums = second.date.split('/') 
      if f_nums[2].to_i != s_nums[2].to_i
        comp =  f_nums[2].to_i <=> s_nums[2].to_i 
      elsif f_nums[0].to_i != s_nums[0].to_i
        comp =  f_nums[0].to_i <=> s_nums[0].to_i 
      else
        comp = f_nums[1].to_i <=> s_nums[1].to_i 
      end 
      comp
    end
    date = '' 
    @log.each do |entry|
      if entry.date.eql? date
        puts '  ' + entry.name
        date = entry.date
      else
        date = entry.date
        puts entry.date
        puts '  ' + entry.name
      end
    end
  end

  #shows all of the entries on a specific date, th default date is today
  def show(date=Time.now.strftime("%d/%m/%Y"))
    hash = Hash.new
    @log.each do |entry| 
      if hash.has_key? entry.name and entry.date.eql? date
        hash[entry.name] += 1 
      else
        if entry.date.eql? date
          hash.store(entry.name,1)
        end
      end
    end 
    hash.each_key do |entry|
      if hash[entry] < 2 
        puts entry
      else 
        puts entry + ' (' + hash[entry].to_s + ') '
      end  
    end
  end

  #Deletes the given entry from the working database
  def delete(args)
    pair = args.split(',') 
    @log.each do |entry|
      if entry.date.eql? pair[0] and entry.name.eql? pair[1] 
        @log.delete(entry)
        break
      end
    end 
  end

end
