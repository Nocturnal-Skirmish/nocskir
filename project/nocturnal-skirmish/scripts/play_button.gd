extends Button

@onready var button_label: Label = $buttonLabel
@onready var hover_offset = Vector2(0, 8)

func _ready():
	# Check if the label exists
	if button_label:
		# Connect hover signals
		self.mouse_entered.connect(_on_button_hovered)
		self.mouse_exited.connect(_on_button_unhovered)

func _on_button_hovered():
	if button_label:
		# Move the label down by offset on hover
		button_label.position += hover_offset

func _on_button_unhovered():
	if button_label:
		# Reset label position
		button_label.position -= hover_offset

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
