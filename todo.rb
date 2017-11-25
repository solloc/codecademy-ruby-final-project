module Menu
	def menu
		"1) Add\n2) Show\n3) Write to file\nQ) Quit"
	end

	def show
		puts menu
	end
end

module Promptable
	def prompt(message="What would you like to do?", symbol=":> ")
		print message
		print symbol
		gets.chomp
	end
end	

class List
	attr_reader :all_tasks

	def initialize
		@all_tasks = []
	end

	def add(task)
		all_tasks << task
	end

	def write_to_file(filename)
		IO.write(filename, @all_tasks.map(&:to_s).join("\n"))
	end

	def show
		all_tasks
	end
end

class Task
	attr_reader :description

	def initialize(description)
		@description = description
	end

	def to_s
		description
	end
end	

if __FILE__ == $PROGRAM_NAME
	include Menu
	include Promptable
	my_list = List.new
	puts "Please choose from the following list"
	until ["q"].include?(user_input = prompt(show).downcase)
		case user_input
			when "1"
				description = prompt("description: \n")
				my_task = Task.new(description)
				my_list.add(my_task)
			when "2"
				puts my_list.show
			when "3"					
				filename = prompt("filename: \n")
				my_list.write_to_file(filename)
			else
				puts "Sorry, I did not understand"				
		end	
	end
	puts "Outro - thanks for using the menu system"
end