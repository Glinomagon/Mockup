extends Node

var world_map: TileMapLayer
var world_terrain_types: Array[String]

func init_world(new_world_map: TileMapLayer, terrain_types: Array[String]) -> void:
	world_map = new_world_map
	world_terrain_types = terrain_types

func get_terrain(position: Vector2) -> String:
	var player_feet: Vector2 = Vector2(position.x, position.y)
	
	var tile_is_on: Vector2 = world_map.local_to_map(player_feet)
	var tile_data: TileData = world_map.get_cell_tile_data(tile_is_on)
	if tile_data:
		var terrain_type_index: int = tile_data.get_custom_data("terrain_type")
		return world_terrain_types[terrain_type_index]
	return "" # they're lost in the void
