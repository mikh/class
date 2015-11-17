################ CHANGELOG #####################
#
# v0.0 - 5/12/15 9:29 Initial Version. Basic ini functions present. Should be used with internal dictionary structure
# v0.1 - 5/12/15 9:30 Small fix in load_ini_file to make sure section items are loaded
# V1.0 - 6/2/15 14:05 Added get_value_default which allows you to get a value or return a default_value if it doesn't exist
# v1.1 - 6/9/15 11:47 Added method to write a single value into an ini file
#
################ END CHANGELOG ################

import configparser

#returns a list of sections in ini
def get_ini_sections(filename):
	config = configparser.RawConfigParser()
	config.read(filename)
	return config.sections()

#returns a list of items in a section
def get_items_in_section(filename, section):
	config = configparser.RawConfigParser()
	config.read(filename)
	if config.has_section(section):
		return config.items(section)
	return False

#return the value of a key in a given section
def get_value(filename, section, key):
	config = configparser.RawConfigParser()
	config.read(filename)
	if config.has_option(section, key):
		return config.get(section, key)
	return False

#returns the value of a key in a given section or the default value if it doesn't exist
def get_value_default(filename, section, key, default_value):
	value = get_value(filename, section, key)
	if value == False:
		value = default_value
	return value

#load an ini file intoa dictionary based object
def load_ini_file(filename):
	config = configparser.RawConfigParser()
	config.read(filename)
	out_d = {}
	sections = config.sections()
	for s in sections:
		out_d[s] = {}
		items = config[s].items()
		for i in items:
			out_d[s][i[0]] = i[1]
	return out_d

#write an object to a filename in ini format
def write_ini_file(filename, obj):
	config = configparser.RawConfigParser()
	for section in obj:
		config.add_section(section)
		for key in obj[section]:
			config.set(section, key, obj[section][key])
	with open(filename, 'w') as f:
		config.write(f)

#writes a value to the same ini file
def write_single_value(filename, section, key, value):
	config = configparser.RawConfigParser()
	config.read(filename)
	if not config.has_section(section):
		config.add_section(section)
	config.set(section, key, value)
	with open(filename, 'w') as f:
		config.write(f)

	