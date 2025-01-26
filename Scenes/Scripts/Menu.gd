extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Chapter1.tscn")

func _on_option_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Options.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit
