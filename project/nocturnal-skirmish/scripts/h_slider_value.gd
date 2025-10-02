extends HSlider

@onready var slider = get_node("HSlider")
@onready var label = get_node("SliderLabel")


func _on_value_changed(value: int) -> void:
	label.text = str(value) + "%"
	
