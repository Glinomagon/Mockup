extends Control

const SWATCH_SCENE: PackedScene = preload("res://Scenes/Component/swatch.tscn")

const MIN_X: int = 140
const ROW_HEIGHT: int = 32

enum BODY_PART { BODY, EYES, HAIR, TOP, BOTTOM }

var BODY_PART_TO_STRING: Dictionary = {
	BODY_PART.TOP: "Top",
	BODY_PART.BOTTOM: "Bottom"
}

var swatches: Dictionary = {
	"skin": Global.SKIN_COLOURS,
	"eyes": Global.EYE_COLOURS,
	"hair": Global.HAIR_COLOURS,
	"clothes": Global.CLOTHING_COLOURS
}

var hair_dictionary: Dictionary = {}
var hair_dictionary_keys: Array = []

var clothing_textures: Dictionary = {
	BODY_PART.TOP: Global.CLOTHES_TOP_PATH,
	BODY_PART.BOTTOM: Global.CLOTHES_BOTTOMS_PATH,
}

var clothing_dictionary: Dictionary = {
	BODY_PART.TOP: {},
	BODY_PART.BOTTOM: {},
}

var clothing_dictionary_keys: Dictionary = {
	BODY_PART.TOP: [],
	BODY_PART.BOTTOM: [],
}

var current_clothing_index: Dictionary = {
	BODY_PART.TOP: 0,
	BODY_PART.BOTTOM: 0,
}

var tabs: Dictionary

@onready var custom_character: CharacterBody2D = $DisplayContainer/SpriteDisplay/CustomPlayer
var hair_texture: Texture2D
var current_hair_index: int

var top_textures: Array[Texture2D]
var bottom_textures: Array[Texture2D]

@onready var body_tab: TabBar = $InterfaceContainer/TabContainer/Body
@onready var eyes_tab: TabBar = $InterfaceContainer/TabContainer/Eyes
@onready var hair_tab: TabBar = $InterfaceContainer/TabContainer/Hair
@onready var top_tab: TabBar = $InterfaceContainer/TabContainer/Top
@onready var bottom_tab: TabBar = $InterfaceContainer/TabContainer/Bottom

var current_tab: BODY_PART = BODY_PART.BODY

func _ready() -> void:
	tabs = {
		BODY_PART.BODY: body_tab,
		BODY_PART.EYES: eyes_tab,
		BODY_PART.HAIR: hair_tab,
		BODY_PART.TOP: top_tab,
		BODY_PART.BOTTOM: bottom_tab,
	}

	_init_textures()
	_init_row_sizes()
	_init_default_swatches()
	_connect_colour_picker_sliders()
	_set_default_colours()

func _init_textures() -> void:
	# load hair texture
	hair_texture = load(Global.PlayerTextures[Global.BODY_PART.HAIR])

	var hair_sprite: Sprite2D = custom_character.get_node("SpriteGroup/Hair")
	hair_sprite.hframes = 5
	hair_sprite.vframes = 3
	hair_sprite.texture = hair_texture

	var hairstyles_count: int = int(hair_texture.get_width() / 16.0) # 16px is the width of player sprite
	for i in range(hairstyles_count + 1): 
		var count: int = i + 1
		var key: String = "Hair "+str(count)
		hair_dictionary[key] = \
			Vector2(i, 0) if count <= hairstyles_count else Vector2(-1, -1)
		hair_dictionary_keys.append(key)
	
	# set default hair
	current_hair_index = 0
	hair_sprite.frame_coords = hair_dictionary[hair_dictionary_keys[current_hair_index]]
	hair_tab.get_node("ContentContainer/ContentDivider/VariantButtons/HBoxContainer/Name").text = hair_dictionary_keys[current_hair_index]
	
	_setup_clothing_textures()

func _init_row_sizes() -> void:
	var colour_picker_min_size: Vector2 = Vector2(0, ROW_HEIGHT * 3)
	var swatch_min_size: Vector2 = Vector2(22, 22)

	for tab: BODY_PART in tabs:
		# set colour picker min size
		tabs[tab].get_node("ContentContainer/ContentDivider/ColourPicker").custom_minimum_size = colour_picker_min_size
		# set swatches min size
		var tab_swatches: GridContainer = tabs[tab].get_node("ContentContainer/ContentDivider/Swatches")
		for swatch: Button in tab_swatches.get_children():
			swatch.custom_minimum_size = swatch_min_size

func _init_default_swatches() -> void:
	for tab: BODY_PART in tabs:
		var tab_swatches: GridContainer = tabs[tab].get_node("ContentContainer/ContentDivider/Swatches")
		_init_swatches_colours(tab, tab_swatches)

func _init_swatches_colours(body_part: BODY_PART, swatches_container: GridContainer) -> void:
	var swatch_name: String
	match body_part:
		BODY_PART.BODY:
			swatch_name = "skin"
		BODY_PART.EYES:
			swatch_name = "eyes"
		BODY_PART.HAIR:
			swatch_name = "hair"
		BODY_PART.TOP, BODY_PART.BOTTOM:
			swatch_name = "clothes"
	
	for colour: String in swatches[swatch_name]:
		var new_swatch: Swatch = SWATCH_SCENE.instantiate()
		new_swatch.set_colour(Color.html(colour))
		swatches_container.add_child(new_swatch)
		new_swatch.colour_selected.connect(_on_swatch_pressed)

func _connect_colour_picker_sliders() -> void:
	for tab: BODY_PART in tabs:
		tabs[tab].get_node("ContentContainer/ContentDivider/ColourPicker").colour_change.connect(_on_colour_change)

func _setup_clothing_textures() -> void:
	for k: BODY_PART in clothing_textures:
		# load textures
		for i: int in clothing_textures[k].size():
			var count: int = i + 1
			var key: String = BODY_PART_TO_STRING[k] + " " + str(count)
			clothing_dictionary[k][key] = load(clothing_textures[k][i])
			clothing_dictionary_keys[k].append(key)
		clothing_dictionary[k]["Naked"] = null
		clothing_dictionary_keys[k].append("Naked")

		# set default
		var texture_key: String = clothing_dictionary_keys[k][current_clothing_index[k]]
		var clothing_texture: Texture2D = clothing_dictionary[k][texture_key]
		tabs[k].get_node("ContentContainer/ContentDivider/VariantButtons/HBoxContainer/Name").text = texture_key

		var node_name: String = "SpriteGroup/" + BODY_PART_TO_STRING[k]
		var clothing_sprite: Sprite2D = custom_character.get_node(node_name)
		clothing_sprite.hframes = 8
		clothing_sprite.vframes = 3
		clothing_sprite.texture = clothing_texture
		clothing_sprite.frame_coords = Vector2(0, 0)

# default brown
func _set_default_colours() -> void:
	# MOVE THIS TO TOP. MOVE HARDCODED TO A DIRECTORY
	var swatch_colours: Array[Color] = [
		Color(swatches["skin"][2]),
		Color(swatches["eyes"][0]),
		Color(swatches["hair"][0]),
		Color(swatches["clothes"][0]),
		Color(swatches["clothes"][6])
	]
	for i: int in range(swatch_colours.size()):
		var part: BODY_PART = BODY_PART.values()[i]
		set_colour(swatch_colours[i], part)
		tabs[part].get_node("ContentContainer/ContentDivider/ColourPicker").set_colour(swatch_colours[i], true)

func set_colour(colour: Color, part: BODY_PART) -> void:
	var tab_name: String
	match part:
		BODY_PART.BODY:
			tab_name = "BodyBase"
		BODY_PART.EYES:
			tab_name = "Pupils"
		BODY_PART.HAIR:
			tab_name = "Hair"
		BODY_PART.TOP:
			tab_name = "Top"
		BODY_PART.BOTTOM:
			tab_name = "Bottom"
	custom_character.get_node("SpriteGroup/" + tab_name).self_modulate = colour

func set_hair(hair_index: int) -> void:
	var hair_key: String = hair_dictionary_keys[hair_index]
	hair_tab.get_node("ContentContainer/ContentDivider/VariantButtons/HBoxContainer/Name").text = hair_key
	var hair_coord: Vector2 = hair_dictionary[hair_key]
	if hair_coord != Vector2(-1, -1):
		custom_character.get_node("SpriteGroup/Hair").texture = hair_texture
		custom_character.get_node("SpriteGroup/Hair").frame_coords = hair_dictionary[hair_key]
	else:
		custom_character.get_node("SpriteGroup/Hair").texture = null

func set_clothes(clothing_area: BODY_PART, clothing_index: int) -> void:
	var dict_key: String = clothing_dictionary_keys[clothing_area][clothing_index]
	var node_name: String = "SpriteGroup/"
	match clothing_area:
		BODY_PART.TOP:
			node_name += "Top"
		BODY_PART.BOTTOM:
			node_name += "Bottom"
	tabs[clothing_area].get_node("ContentContainer/ContentDivider/VariantButtons/HBoxContainer/Name").text = dict_key
	custom_character.get_node(node_name).texture = clothing_dictionary[clothing_area][dict_key]
	custom_character.get_node(node_name).frame_coords = Vector2(0, 0)

# -1 for previous, +1 for next
func _change_selection(direction: int) -> void:
	match current_tab:
		BODY_PART.HAIR:
			current_hair_index = (current_hair_index + direction + hair_dictionary_keys.size()) % hair_dictionary_keys.size()
			set_hair(current_hair_index)
		BODY_PART.TOP, BODY_PART.BOTTOM:
			var num_keys: int = clothing_dictionary_keys[current_tab].size()
			current_clothing_index[current_tab] = (current_clothing_index[current_tab] + direction + num_keys) % num_keys
			set_clothes(current_tab, current_clothing_index[current_tab])
		
# signals
func _on_colour_change(colour: Color) -> void:
	set_colour(colour, current_tab)

func _on_swatch_pressed(colour: Color) -> void:
	set_colour(colour, current_tab)
	tabs[current_tab].get_node("ContentContainer/ContentDivider/ColourPicker").set_colour(colour, true)

func _on_tab_container_tab_changed(tab: int) -> void:
	current_tab = tab as BODY_PART

func _on_prev_pressed() -> void:
	_change_selection(-1)

func _on_next_pressed() -> void:
	_change_selection(1)