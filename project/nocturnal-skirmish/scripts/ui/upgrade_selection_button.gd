extends Button
class_name UpgradeSelectionButton

@onready var name_label = $HBoxContainer/Choice1/VBoxContainer/MarginContainer/UpgradeName
@onready var description_label = $HBoxContainer/Choice1/VBoxContainer/MarginContainer2/UpgradeDescription

# Function to instantiate self
static func instantiate_scene() -> Node:
	var scene = preload("res://scenes/ui/upgrade_selection_button.tscn")
	return scene.instantiate()

# Function to update the button with correct info
func update_button(upgrade_object, level: int = 1) -> void:
	name_label.text = upgrade_object.display_name
	description_label.text = upgrade_object.levels[level].description
