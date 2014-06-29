require_relative 'library'
require_relative 'generator'

def clear mode=:all
	case mode
	when :all
		Library.clear
		Generator.clear
	when :characters
		Library.clear_characters
	end
end

def debug device, status=true
	if device == :library
		Library.debug !!status
		Library.dputs "-- Library debugging on --"
	elsif device == :generator
		Generator.debug !!status
		Generator.dputs "-- Generator debugging #{!!status ? 'on' : 'off'} --"
	end
end

def get obj
	case obj
	when :characters
		Library.characters
	end
end

######################
### LIBRARY        ###
######################

def level level
	Library.add_level level
	Library.dputs "#{level}"
end

def category cat
	Library.update_last_level cat
	Library.add_category cat
	Library.dputs "---> #{cat}"
end

def trait trait
	Library.update_last_cat trait
	Library.dputs "--- ---> #{trait}"
end

def character name, *traits
	Library.add_character name, traits
	Library.dputs "#{Library.last_character.name}: #{Library.last_character.traits}"
end

######################
### GENERATOR      ###
######################

def set seed
	Generator.use_seed seed
end

def pattern *args
	Generator.create_pattern *args
	Generator.dputs Generator.last_pattern
end

def generate n
	Generator.dputs "\n--- Generating #{n} characters ---"
	Generator.generate n
end
