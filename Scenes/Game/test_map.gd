extends Node2D

@onready var base_ground: TileMapLayer = $"Y-Sorting/Map/Path"
@onready var player: CharacterBody2D = $"Y-Sorting/CustomPlayer"
@onready var camera: Camera2D = $Camera2D

var terrain_types: Array[String] = ["Grass", "Dirt"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameWorldManager.init_world(base_ground, terrain_types)

	var used_rect : Rect2i = base_ground.get_used_rect()
	var map_size : Vector2 = base_ground.map_to_local(used_rect.size - Vector2i(1, 1))
	var map_position : Vector2 = base_ground.map_to_local(used_rect.position)

	camera.limit_left = int(map_position.x - 16)
	camera.limit_right = int(map_position.x + map_size.x)
	camera.limit_top = int(map_position.y - 16)
	camera.limit_bottom = int(map_position.y + map_size.y)
	camera.zoom = Vector2(2, 2)

func _physics_process(_delta: float) -> void:
	camera.position = player.position