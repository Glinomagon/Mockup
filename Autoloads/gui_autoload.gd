extends CanvasLayer

var gui_components: Array[String] = [
	"res://Scenes/Settings.tscn"
]

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

enum WINDOW_MODE { FULLSCREEN, WINDOWED, BORDERLESS }

var STRING_TO_WINDOW_MODE: Dictionary = {
	"Fullscreen": WINDOW_MODE.FULLSCREEN,
	"Windowed": WINDOW_MODE.WINDOWED,
	"Borderless": WINDOW_MODE.BORDERLESS
}

var WINDOW_MODE_TO_STRING: Dictionary = {
	WINDOW_MODE.FULLSCREEN: "Fullscreen",
	WINDOW_MODE.WINDOWED: "Windowed",
	WINDOW_MODE.BORDERLESS: "Borderless"
}

var current_resolution: String
var current_window_mode: WINDOW_MODE

signal resolution_changed(new_res: String)

func _ready() -> void:
	# load default values from config
	current_resolution = ConfigManager.CONFIG_VALUES[ConfigConstants.WINDOW][ConfigConstants.RESOLUTION]
	current_window_mode = STRING_TO_WINDOW_MODE[ConfigManager.CONFIG_VALUES[ConfigConstants.WINDOW][ConfigConstants.WINDOW_MODE]]
	
	if current_resolution:
		change_window_resolution(current_resolution)
	if current_window_mode:
		change_window_mode(WINDOW_MODE_TO_STRING[current_window_mode])

func change_window_resolution(new_res: String) -> void:	
	current_resolution = new_res
	var new_size: Vector2i = resolutions.get(new_res)
	get_window().size = new_size
	ConfigManager.save_value(ConfigConstants.CONFIG_SECTION.WINDOW, ConfigConstants.RESOLUTION, new_res)
	resolution_changed.emit(new_res) # emit signal when resolution changes
	
	#center window
	DisplayServer.window_set_position(DisplayServer.screen_get_size() * 0.5 - DisplayServer.window_get_size() * 0.5)

func change_window_mode(mode: String) -> void:
	var new_res: String
	if STRING_TO_WINDOW_MODE[mode] == WINDOW_MODE.FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		# check 
		var max_screen: Vector2i = DisplayServer.screen_get_size()
		if resolution_is_supported(max_screen):
			new_res = str(max_screen.x) + "x" + str(max_screen.y)
		else:
			new_res = get_closest_resolution(max_screen)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		if STRING_TO_WINDOW_MODE[mode] == WINDOW_MODE.WINDOWED:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		else:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		# change resolution since window looks weird if you don't
		new_res = current_resolution
	change_window_resolution(new_res)
	current_window_mode = STRING_TO_WINDOW_MODE[mode]
	ConfigManager.save_value(ConfigConstants.CONFIG_SECTION.WINDOW, ConfigConstants.WINDOW_MODE, mode)

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

func resolution_is_supported(res: Vector2i) -> bool:
	for r: Vector2i in resolutions.values():
		if r == res:
			return true
	return false
