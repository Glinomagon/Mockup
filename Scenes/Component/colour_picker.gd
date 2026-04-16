extends Control
class_name ColourPicker

signal colour_change()

const MIN_X: int = 140
const ROW_HEIGHT: int = 32

var ui: Dictionary = {}

@onready var red_slider: Slider = $Sections/SlidersContainer/Sliders/RedSlider
@onready var red_value_input: LineEdit = $Sections/ValuesContainer/Values/RedEdit
@onready var red_label: Label = $Sections/LabelsContainer/Labels/RedLabel
@onready var green_slider: Slider = $Sections/SlidersContainer/Sliders/GreenSlider
@onready var green_value_input: LineEdit = $Sections/ValuesContainer/Values/GreenEdit
@onready var green_label: Label = $Sections/LabelsContainer/Labels/GreenLabel
@onready var blue_slider: Slider = $Sections/SlidersContainer/Sliders/BlueSlider
@onready var blue_value_input: LineEdit = $Sections/ValuesContainer/Values/BlueEdit
@onready var blue_label: Label = $Sections/LabelsContainer/Labels/BlueLabel

@export var red: float
@export var green: float
@export var blue: float

func _ready() -> void:
	init_row_sizes()
	init_ui_dictionary()
	init_slider_values()

# Set min row sizes
func init_row_sizes() -> void:
	var lists: Array[Node] = find_children("", "VBoxContainer", true)
	for list: VBoxContainer in lists:
		for child:Control in list.get_children():
			if child is Label:
				child.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
				child.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			
			if ["RedValue","GreenValue", "BlueValue"].has(child.name):
				child.custom_minimum_size = Vector2(50, ROW_HEIGHT)
			else:
				child.custom_minimum_size = Vector2(0, ROW_HEIGHT)

func init_ui_dictionary() -> void:
	ui = {
		"r": {
			"label": red_label,
			"slider": red_slider,
			"value_input": red_value_input,
		},
		"g": {
			"label": green_label,
			"slider": green_slider,
			"value_input": green_value_input,
		},
		"b": {
			"label": blue_label,
			"slider": blue_slider,
			"value_input": blue_value_input,
		}
	}

func init_slider_values() -> void:
	# set max size
	for channel: String in ["r", "g", "b"]:
		ui[channel]["slider"].max_value = 255.0

	# change visible value labels
	ui["r"]["value_input"].text = str(int(red))
	ui["g"]["value_input"].text = str(int(green))
	ui["b"]["value_input"].text = str(int(blue))

func get_colour() -> Color:
	return Color(red/255.0, blue/255.0, green/255.0)

func set_colour(colour: Color, silent: bool = false) -> void:
	red = colour.r8
	green = colour.g8
	blue = colour.b8

	if silent:
		for channel: String in ui.keys():
			ui[channel]["slider"].set_block_signals(true)
	
	ui["r"]["slider"].value = red
	ui["g"]["slider"].value = green
	ui["b"]["slider"].value = blue

	ui["r"]["value_input"].text = str(int(red))
	ui["g"]["value_input"].text = str(int(green))
	ui["b"]["value_input"].text = str(int(blue))

	if silent:
		for channel: String in ui.keys():
			ui[channel]["slider"].set_block_signals(false)
	
	if !silent:
		colour_change.emit(Color(red/255.0, green/255.0, blue/255.0))

func get_colour_channel(channel: String) -> float:
	match channel.to_lower():
		"red", "r":
			return red
		"green", "g":
			return green
		"blue", "b":
			return blue
	# send error
	assert(false, "Invalid colour channel: " + channel)
	return 0.0

func set_colour_channel(channel: String, value: float) -> void:
	match channel.to_lower():
		"red", "r":
			red = value
			ui["r"]["value_input"].text = str(int(red))
			ui["r"]["slider"].value = red
		"green", "g":
			green = value
			ui["g"]["value_input"].text = str(int(green))
			ui["g"]["slider"].value = green
		"blue", "b":
			blue = value
			ui["b"]["value_input"].text = str(int(blue))
			ui["b"]["slider"].value = blue
		_:
			# send error
			assert(false, "Invalid colour channel: " + channel)
	colour_change.emit(Color(red/255.0, green/255.0, blue/255.0))


# signals
func _on_red_slider_value_changed(value: float) -> void:
	set_colour_channel("r", value)

func _on_green_slider_value_changed(value: float) -> void:
	set_colour_channel("g", value)

func _on_blue_slider_value_changed(value: float) -> void:
	set_colour_channel("b", value)

func _on_red_edit_text_submitted(new_text: String) -> void:
	if new_text.is_valid_float():
		set_colour_channel("r", float(new_text))

func _on_green_edit_text_submitted(new_text: String) -> void:
	if new_text.is_valid_float():
		set_colour_channel("g", float(new_text))

func _on_blue_edit_text_submitted(new_text: String) -> void:
	if new_text.is_valid_float():
		set_colour_channel("b", float(new_text))
