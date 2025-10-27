extends Control

@onready var host_game_button = $HostButton
@onready var join_game_button = $JoinButton
@onready var back_button = $BackButton


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game_ui.tscn")

func _on_host_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
