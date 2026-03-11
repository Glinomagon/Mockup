#WINDOW IS SET TO OPEN IN SECONDARY MONITOR FOR NOW. FOR TESTING PURPOSES
extends Node2D

func _on_start_button_pressed() -> void:
	print("Start button pressed")

func _on_settings_button_pressed() -> void:
	print("Settings button pressed")
	Switcher.change_scene(Directory.scene_dir.SETTINGS)
