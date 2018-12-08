require 'yaml'
require './task'

require 'bundler'
Bundler.require

module Todo
  class Main
    def initialize
      @backlog = []
      @done = []

      daily_tasks =  YAML.load_file('./daily_task.yml')

      daily_tasks["tasks"].each_value do |val|
        @backlog.push(Task.new(val['name']))
      end

      start
    end

    def show_board (tasks)
      tasks.each do |t|
        t.show 
      end
    end

    def show_backlog
      puts '== backlog =='
      if @backlog.length == 0
        puts '- No task in backlog. Plz add task! -'
      else
        show_board(@backlog)
      end
    end

    def show_done
      puts '== done =='
      if @done.length == 0
        puts '- No task in done. Plz complete task. -'
      else
        show_board(@done)
      end
    end

    def add_backlog
      name = TTY::Reader.new.read_line
      new_task = Task.new(name.gsub(/\n/, ""))
      @backlog.push(new_task)

      puts "Add #{new_task.get_name} to backlog."
    end

    def complete_task
      if @backlog.length == 0
        puts 'No task in backlog...'
        return
      end

      task = TTY::Prompt.new.select('Please select complete task!') do |menu|
        @backlog.each_with_index do |t, index|
          menu.choice t.get_name, {t: t, index: index}
        end
      end

      @backlog.delete_at(task[:index])
      task[:t].complete
      @done.push(task[:t])
    end

    def loop_function
      show_backlog
      show_done

      behavior = TTY::Prompt.new.select('Please select your acrion!') do |menu|
        menu.choice 'add task'
        menu.choice 'complete task'
        menu.choice 'exit'
      end

      return if behavior == 'exit'

      case behavior
        when 'add task'
          add_backlog
        when 'complete task'
          complete_task
      end

      loop_function
    end

    def start
      puts 'hello, Have a nice day!'

      loop_function

      puts 'Good bye...'
    end
  end

  Main.new
end
