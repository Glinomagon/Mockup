extends Node2D

@onready var base_ground: TileMapLayer = $Path
@onready var player: CharacterBody2D = $Player

var terrain_types: Array[String] = ["Grass", "Dirt"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameWorldManager.init_world(player, base_ground, terrain_types)

	var used_rect : Rect2i = base_ground.get_used_rect()
	var map_size : Vector2 = base_ground.map_to_local(used_rect.size - Vector2i(1, 1))
	var map_position : Vector2 = base_ground.map_to_local(used_rect.position)
	
	get_node("Player").set_camera_limit(
		map_position.x,
		map_position.x + map_size.x,
		map_position.y,
		map_position.y + map_size.y
	)

func _process(_delta: float) -> void:
	pass