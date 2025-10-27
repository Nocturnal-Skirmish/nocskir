extends Control

@onready var host_game_button = $MarginContainer/MarginContainer/MarginContainer/MarginContainer/VBoxContainer/HostButton
@onready var join_game_button = $MarginContainer/MarginContainer/MarginContainer/MarginContainer/VBoxContainer/VBoxContainer/JoinButton
@onready var back_button = $MarginContainer/MarginContainer/MarginContainer/MarginContainer/BackButton
@onready var ip_input = $MarginContainer/MarginContainer/MarginContainer/MarginContainer/VBoxContainer/VBoxContainer/LineEdit


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game_ui.tscn")

func _on_host_button_pressed() -> void:
	HighLevelNetworkHandler.start_server()
	get_tree().change_scene_to_file("res://scenes/main.tscn")

# same behaviour as pressing enter on lineedit
func _on_join_button_pressed() -> void:
	HighLevelNetworkHandler.start_client()
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	ip_input._on_text_submitted(ip_input.text)
