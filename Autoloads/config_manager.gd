extends Node

var config: ConfigFile = ConfigFile.new()

"""
	Config values that gets updated during runtime, settings page should read
	from here and not directly from config file
"""
var CONFIG_VALUES: Dictionary = {
	ConfigConstants.WINDOW:
		{
			ConfigConstants.RESOLUTION: "",
			ConfigConstants.WINDOW_MODE: "",
			ConfigConstants.BORDERLESS_MODE: "",
		}
}

func _ready() -> void:
	# load or create config
	var err: Error = config.load("res://Config/config.cfg")
	
	if err != OK:
		print("Config file not found, creating new config")
		config = ConfigFile.new()
		config.save("res://Config/config.cfg")
	else:
		init_config()

# read values from config file
func init_config() -> void:
	for section in config.get_sections():
		for value: String in CONFIG_VALUES[section].keys():
			CONFIG_VALUES[section][value] = config.get_value(section, value, "") # Default value ""

func save_value(section: ConfigConstants.CONFIG_SECTION, value_name: String, value: String) -> void:
	config.set_value(ConfigConstants.CONFIG_SECTION_TO_STRING[section], value_name, value)
	# test where this would be in a build
	config.save("res://Config/config.cfg")
