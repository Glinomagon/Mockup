extends CanvasLayer 

signal window_mode_change(window_mode: String)

enum WINDOW_MODE { FULLSCREEN, WINDOWED }

var resolutions: Dictionary = {
	"640x360": Vector2i(640, 360),
	"854x480": Vector2i(854, 480),
	"960x540": Vector2i(960, 540),
	"1024x576": Vector2i(1024, 576),
	"1280x720": Vector2i(1280, 720),
	"1366x768": Vector2i(1366, 768),
	"1600x900": Vector2i(1600, 900),
	"1920x1080": Vector2i(1920, 1080),
	"2048x1152": Vector2i(2048, 1152),
	"2560x1440": Vector2i(2560, 1440),
}

var STRING_TO_WINDOW_MODE: Dictionary = {
	"Fullscreen": WINDOW_MODE.FULLSCREEN,
	"Windowed": WINDOW_MODE.WINDOWED,
}

var WINDOW_MODE_TO_STRING: Dictionary = {
	WINDOW_MODE.FULLSCREEN: "Fullscreen",
	WINDOW_MODE.WINDOWED: "Windowed",
}

var current_resolution: String
var current_window_mode: WINDOW_MODE
var is_borderless: bool

func _ready() -> void:
	load_config_values()

func _exit_tree() -> void:
	# if closing on a fullscreen, change config resolution to fullscreen resolution
	# last window resolution is only remembered per session
	if current_window_mode == WINDOW_MODE.FULLSCREEN:
		var max_resolution: String = get_closest_resolution(DisplayServer.screen_get_size())
		ConfigManager.save_value(ConfigConstants.CONFIG_SECTION.WINDOW, ConfigConstants.RESOLUTION, max_resolution)

func load_config_values() -> void:
	# load default values from config
	current_resolution = ConfigManager.CONFIG_VALUES[ConfigConstants.WINDOW][ConfigConstants.RESOLUTION]
	current_window_mode = STRING_TO_WINDOW_MODE[ConfigManager.CONFIG_VALUES[ConfigConstants.WINDOW][ConfigConstants.WINDOW_MODE]]
	var current_borderless_mode: String = ConfigManager.CONFIG_VALUES[ConfigConstants.WINDOW][ConfigConstants.BORDERLESS_MODE]
	is_borderless = current_borderless_mode.to_lower() == "true"

	if current_resolution:
		change_window_resolution(current_resolution)
	if current_window_mode:
		change_window_mode(WINDOW_MODE_TO_STRING[current_window_mode])
	change_borderless_mode(is_borderless)
	
func change_borderless_mode(mode: bool) -> void:
	is_borderless = mode
	ConfigManager.save_value(ConfigConstants.CONFIG_SECTION.WINDOW, ConfigConstants.BORDERLESS_MODE, str(mode))

	# early return for exclusive fullscreen
	if !mode && current_window_mode == WINDOW_MODE.FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		return

	var size: Vector2i
	if current_window_mode == WINDOW_MODE.FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		var max_screen: String = get_closest_resolution(DisplayServer.screen_get_size())
		size = resolutions.get(max_screen)
	else:
		size = resolutions.get(current_resolution)
	
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, mode)
	# resize so there's no black borders when going borderless
	get_window().size = size

func change_window_resolution(new_res: String) -> void:	
	current_resolution = new_res
	var new_size: Vector2i = resolutions.get(new_res)
	get_window().size = new_size
	ConfigManager.save_value(ConfigConstants.CONFIG_SECTION.WINDOW, ConfigConstants.RESOLUTION, new_res)
	
	#center window
	DisplayServer.window_set_position(DisplayServer.screen_get_size() * 0.5 - DisplayServer.window_get_size() * 0.5)

func change_window_mode(mode: String) -> void:
	if STRING_TO_WINDOW_MODE[mode] == WINDOW_MODE.FULLSCREEN:
		if is_borderless:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	elif STRING_TO_WINDOW_MODE[mode] == WINDOW_MODE.WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		if is_borderless:
			# change resolution since window looks weird if you don't
			var size: Vector2i = resolutions.get(current_resolution)
			get_window().size = size
			DisplayServer.window_set_position(DisplayServer.screen_get_size() * 0.5 - DisplayServer.window_get_size() * 0.5)
	current_window_mode = STRING_TO_WINDOW_MODE[mode]
	ConfigManager.save_value(ConfigConstants.CONFIG_SECTION.WINDOW, ConfigConstants.WINDOW_MODE, mode)
	window_mode_change.emit(mode)

func get_closest_resolution(screen_size: Vector2i) -> String:
	var closest: Vector2i
	var will_fit: Array
	
	for r: Vector2i in resolutions.values():
		if screen_size.x >= r.x:
			will_fit.append(r)
	will_fit.sort()
	closest = will_fit[will_fit.size() - 1]
	# turn closest into a resolutions key
	return str(closest.x) + "x" + str(closest.y)