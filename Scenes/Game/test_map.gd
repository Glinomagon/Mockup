extends Node2D

@onready var base_ground: TileMapLayer = $"Y-Sorting/Map/Path"
@onready var player: CharacterBody2D = $"Y-Sorting/Player"

var terrain_types: Array[String] = ["Grass", "Dirt"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameWorldManager.init_world(player, base_ground, terrain_types)

	var used_rect : Rect2i = base_ground.get_used_rect()
	var map_size : Vector2 = base_ground.map_to_local(used_rect.size - Vector2i(1, 1))
	var map_position : Vector2 = base_ground.map_to_local(used_rect.position)
	
	player.set_camera_limit(
		# Don't really know why the constants are needed but the value is ground tilesize/2
		map_position.x - 16,
		map_position.x + map_size.x,
		map_position.y - 16,
		map_position.y + map_size.y
	)

func _process(_delta: float) -> void:
	pass
