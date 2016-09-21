class LogItem
  def initialize(date,name)
    @date = date
    @name = name
  end

  attr_reader :name, :date
end
