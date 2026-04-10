extends Control

const MIN_X: int = 140
const ROW_HEIGHT: int = 32

@onready var labels_container: VBoxContainer = $ScreenContainer/ScreenDivider/SettingsContainer/Labels
@onready var interactables_container: VBoxContainer = $ScreenContainer/ScreenDivider/SettingsContainer/Interactables
@onready var window_mode_option: OptionButton = $ScreenContainer/ScreenDivider/SettingsContainer/Interactables/WindowModeOption
@onready var resolution_option: OptionButton = $ScreenContainer/ScreenDivider/SettingsContainer/Interactables/ResolutionOption
@onready var borderless_toggle: CheckBox = $ScreenContainer/ScreenDivider/SettingsContainer/Interactables/BorderlessToggle
@onready var buttons_container: HBoxContainer = $ScreenContainer/ScreenDivider/ButtonsContainer/ButtonsDivider
var disable_resolution_option: bool

func _ready() -> void:
	set_row_sizes()
	init_resolution_option()
	init_window_mode_option()
	# init borderless toggle
	borderless_toggle.button_pressed = GuiAutoload.is_borderless
	# connect signal from GuiAutoload
	GuiAutoload.window_mode_change.connect(_on_window_mode_change)
	# disable resolution option if fullscreen
	resolution_option.disabled = true if GuiAutoload.current_window_mode == GuiAutoload.WINDOW_MODE.FULLSCREEN else false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_row_sizes() -> void:
	#set default min sizes
	for child: Label in labels_container.get_children():
		child.custom_minimum_size = Vector2(0, ROW_HEIGHT)

	var max_popup_height: int = int(DisplayServer.window_get_size().y * 0.25)
	for child: Button in interactables_container.get_children():
		child.custom_minimum_size = Vector2(MIN_X, ROW_HEIGHT)
		# set popup menu max size if child is an option button
		if child is OptionButton:
			child.get_popup().max_size = Vector2(MIN_X, max_popup_height)
	
	for button: Button in buttons_container.get_children():
		button.custom_minimum_size = Vector2(MIN_X, ROW_HEIGHT)

func init_resolution_option() -> void:
	for r: String in GuiAutoload.resolutions:
		resolution_option.add_item(r)

	# set default resolution picked. If there's nothing from config, just use the first available.
	var default_resolution_index: int = get_size_option_id(GuiAutoload.current_resolution)
	if default_resolution_index == -1:
		default_resolution_index = 0
	resolution_option.selected = default_resolution_index

func init_window_mode_option() -> void:
	for m: String in GuiAutoload.WINDOW_MODE:
		var mode: GuiAutoload.WINDOW_MODE = GuiAutoload.WINDOW_MODE[m]
		window_mode_option.add_item(GuiAutoload.WINDOW_MODE_TO_STRING[mode])

	# set default window_option. If there's nothing from config, just query what it is
	window_mode_option.selected = GuiAutoload.current_window_mode

func get_size_option_id(text: String) -> int:
	for i: int in range(resolution_option.item_count):
		if resolution_option.get_item_text(i) == text:
			return resolution_option.get_item_id(i)
	return -1

func _on_exit_button_pressed() -> void:
	Switcher.change_scene(Directory.scene_dir.MAIN_MENU)

func _on_resolution_option_item_selected(index: int) -> void:
	var resolution: String = resolution_option.get_item_text(index)
	GuiAutoload.change_window_resolution(resolution)

func _on_borderless_toggle_toggled(toggled_on: bool) -> void:
	GuiAutoload.change_borderless_mode(toggled_on)
	# need to have check here that disables resolution if window mode = fullscreen

func _on_window_mode_option_item_selected(index: int) -> void:
	var window_mode: String = window_mode_option.get_item_text(index)
	GuiAutoload.change_window_mode(window_mode)

func _on_window_mode_change(window_mode: String) -> void:
	resolution_option.disabled = true if window_mode == ConfigConstants.FULLSCREEN else false
