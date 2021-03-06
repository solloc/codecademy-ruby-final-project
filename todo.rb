module Menu
	def menu
		"1) Add\n2) Show\n3) Delete\n4) Update\n5) Write to file\n6) Read from file\n7) Toggle status\nQ) Quit"
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

	def delete(id)
		all_tasks.delete_at(id - 1)
	end

	def update(id, task)
		all_tasks[id-1] = task
	end

	def toggle(id)
		@all_tasks[id-1].toggle_status
	end

	def write_to_file(filename)
		machinified = @all_tasks.map(&:to_machine).join("\n")
		IO.write(filename, machinified)
		# IO.write(filename, @all_tasks.map(&:to_s).join("\n"))
	end

	def read_from_file(filename)
		IO.readlines(filename).each do |line|
			status, *description = line.split(':')
			status = status.include?('X')
			add(Task.new(description.join(':').strip, status))
			# add(Task.new(line.chomp))
		end
	end

	def show
		all_tasks.map.with_index { |l, i| "(#{i.next}): #{l}"}
	end
end

class Task
	attr_reader :description
	attr_accessor :status

	def initialize(description, status=false)
		@description = description
		@status = status
	end

	def to_s
		represent_status + ":" + description
	end

	def completed?
		status
	end

	def to_machine
		represent_status + ":" + description
	end

	def toggle_status
		@status = !@status
	end

	private

	def represent_status
		completed? ? "[x]" : "[ ]"
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
				puts my_list.show
				id_to_delete = prompt("select task\n").to_i
				my_list.delete(id_to_delete)
			when "4"
				puts my_list.show
				id_to_update = prompt("Which task to update\n").to_i
				new_task = Task.new(prompt("description"))
				my_list.update(id_to_update, new_task)
				puts my_list.show
			when "5"					
				filename = prompt("filename: \n")
				my_list.write_to_file(filename)
			when "6"
				filename = prompt("filename: \n")
				begin
					my_list.read_from_file(filename)
				rescue Errno::ENOENT => e
					puts "file not found"
				end				
			when "7"
				puts my_list.show
				task_to_toggle = prompt("Task number to toggle?").to_i
				my_list.toggle(task_to_toggle)
				puts my_list.show
			else
				puts "Sorry, I did not understand"				
		end	
	end
	puts "Outro - thanks for using the menu system"
end