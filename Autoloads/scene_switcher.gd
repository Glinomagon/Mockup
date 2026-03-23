extends Node

const STARTUP_SCENE = "res://Scenes/Main.tscn"
var current_scene_dir : String

# maybe not needed (consider having this though if we have a loading screen)
func set_startup() -> void:
	get_tree().call_deferred("change_scene_to_file", STARTUP_SCENE)
	
func change_scene(next_scene: String) -> void:
	get_tree().call_deferred("change_scene_to_file", next_scene)
	current_scene_dir = next_scene
