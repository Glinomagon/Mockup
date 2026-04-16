extends Button
class_name Swatch

signal colour_selected(colour: Color)

var colour_rect: ColorRect

@export var colour: Color
var normal: StyleBoxFlat = StyleBoxFlat.new()
var hovered: StyleBoxFlat = StyleBoxFlat.new()

func _ready() -> void:
	normal.bg_color = colour
	hovered.bg_color = colour
	hovered.set_border_width_all(2)
	hovered.border_color = Color(0,0,0)

	add_theme_stylebox_override("normal", normal)
	add_theme_stylebox_override("hover", hovered)
	add_theme_stylebox_override("pressed", hovered)

	colour_rect = ColorRect.new()
	custom_minimum_size = Vector2(22, 22)

func set_colour(new_colour: Color) -> void:
	colour = new_colour
	normal.bg_color = colour
	hovered.bg_color = colour
	if colour_rect != null:
		colour_rect.color = colour

func get_colour() -> Color:
	return colour

func _on_pressed() -> void:
	colour_selected.emit(colour)
