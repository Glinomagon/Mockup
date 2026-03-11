extends Node2D

const POPUP_MAX_SIZE = Vector2i(132, 120)

@onready var size_option: OptionButton = $ScreenSizeField/sizeOption
@onready var window_option: OptionButton = $WindowModeField/windowOption

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# connect signal from gui_autoload
	GuiAutoload.resolution_changed.connect(_on_resolution_change)
	
	# init resolution
	size_option.get_popup().max_size = POPUP_MAX_SIZE	
	for r in GuiAutoload.resolutions:
		size_option.add_item(r)
	
	# set default size_option picked item. If there's nothing from config, juse use first
	var default_size_option_index = get_size_option_id(GuiAutoload.current_resolution)
	if default_size_option_index == -1:
		default_size_option_index = 0
	size_option.selected = default_size_option_index
	
	# init window mode
	window_option.get_popup().max_size = POPUP_MAX_SIZE
	for m in GuiAutoload.WINDOW_MODE:
		var mode = GuiAutoload.WINDOW_MODE[m]
		window_option.add_item(GuiAutoload.WINDOW_MODE_TO_STRING[mode])
	
	# set default window_option. If there's nothing from config, just query what it is
	print(GuiAutoload.current_window_mode)
	window_option.selected = GuiAutoload.current_window_mode
	
	var default_window_mode_option_index = 0

func get_size_option_id(text):
	for i in range(size_option.item_count):
		if size_option.get_item_text(i) == text:
			return size_option.get_item_id(i)
	return -1

func _on_exit_button_pressed() -> void:
	Switcher.change_scene(Directory.scene_dir.MENU)

func _on_size_option_item_selected(index: int) -> void:
	var res_string = size_option.get_item_text(index)
	GuiAutoload.change_window_resolution(res_string)

func _on_window_option_item_selected(index: int) -> void:
	var mode_string = window_option.get_item_text(index)
	GuiAutoload.change_window_mode(mode_string)

func _on_resolution_change(new_res) -> void:
	size_option.selected = get_size_option_id(new_res)
