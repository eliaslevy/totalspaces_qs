#!/usr/bin/env ruby

require 'totalspaces2'
TS2 = TotalSpaces2

def add(space_name, display=nil)
	space_name_check space_name

	if display
		display_id = get_display_id display
	else
		display_id = TS2.main_display[:display_id]
	end

	unless TS2.add_desktops_on_display 1, display_id
		raise "Could not add space. Maximum number of spaces reached on display."
	end
	sleep 0.5
	space_num = TS2.number_of_spaces_on_display display_id
	TS2.set_name_for_space_on_display space_num, space_name, display_id
end

def switch(space_name)
	space = space_find_matching space_name
	TS2.move_to_space_on_display space[:space_num], space[:display_id]
end

def rename(space_name, new_name)
	space_name_check new_name
	space = space_find_matching space_name
	TS2.set_name_for_space_on_display space[:space_num], new_name, space[:display_id]
end

def remove(space_name)
	space = space_find_matching space_name
	num_spaces = TS2.number_of_spaces_on_display space[:display_id]

	unless TS2.move_space_to_position_on_display space[:space_num], num_spaces, space[:display_id]
		raise "Can't remove space \"#{space_name}\"."
	end
	sleep 0.5
	unless TS2.remove_desktops_on_display 1, space[:display_id]
		raise "Can't remove space \"#{space_name}\"."
	end
end

def move_window(window_title, space_name)
	space = space_find_matching space_name
	window_id = get_window_id window_title
	TS2.move_window_to_space_on_display window_id, space[:space_num], space[:display_id]
	TS2.set_front_window window_id
end

def get_display_id(name)
	displays = TS2.display_list

	case name
	when /\A\d+\z/
		name = name.to_i
		return name unless displays.find { |d| d[:display_id] == name }.nil?

	when /.+/
		display = displays.find { |d| d[:display_name].downcase == name.downcase }
		return display[:display_id] unless display.nil?
	end

	raise "Can't find display \"#{name}\"."
end

def get_window_id(window_title)
	window = TS2.window_list.find { |w| w[:title] == window_title }
	raise "Can't find window titled \"#{window_title}\"." if window.nil?
	window[:window_id]
end

def space_find(name)
	space = space_list.find { |s| s[:space_name].downcase == name.downcase }
	return space unless space.nil?
	raise "Can't find space \"#{name}\"."
end

def space_find_matching(partial_name)
	spaces = space_list.select  { |s| s[:space_name].downcase[partial_name.downcase] }
	return spaces.first if spaces.length == 1
	raise "Can't find space \"#{partial_name}\"." if spaces.empty?

	exact_match = spaces.select { |s| s[:space_name].downcase == partial_name.downcase }
	return exact_match.first if exact_match.length == 1

	raise "More than one space match the string \"#{partial_name}\"." unless spaces.length == 1
end

def space_list
	displays = TS2.display_list

	displays.map do |display|

		num_spaces = TS2.number_of_spaces_on_display display[:display_id]

		(1..num_spaces).map do |space_num|
			{
				display_id: display[:display_id],
				space_num:  space_num,
				space_name: TS2.name_for_space_on_display(space_num, display[:display_id])
			}
		end

	end.flatten(1)
end

def space_name_check(space_name)
	space = space_find(space_name) rescue nil
	raise "The name \"#{space_name}\" is already in use." unless space.nil?
end


begin

	case ARGV[0]
		when 'add'
			add ARGV[1], ARGV[2]
		when 'switch'
			switch ARGV[1]
		when 'rename'
			rename ARGV[1], ARGV[2]
		when 'remove'
			remove ARGV[1]
		when 'move_window'
			move_window ARGV[1], ARGV[2]
	end

rescue => e
	puts "Error: #{e}"
end
