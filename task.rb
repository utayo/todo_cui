class Task
  def initialize (name, completed=false)
    @name = name
    @completed = completed
  end

  def get_name
    @name
  end

  def is_completed
    @complated
  end

  def str_completed
    return "Done." if @completed

    "Back log."
  end

  def show
    # puts "#{@name} : #{str_completed}"
    puts "#{@name}"
  end

  def complete
    @completed = true unless @completed
  end
end
