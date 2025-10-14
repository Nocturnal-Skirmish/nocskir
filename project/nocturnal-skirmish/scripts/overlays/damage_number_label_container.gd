class_name DamageNumberLabelContainerScene
extends Control

@onready var damage_label_text: String = $DamageNumberLabelBox/DamageNumberLabel.text
@onready var shader_mat: ShaderMaterial

@export var fade_speed := 1.0 # how fast the label fades out (opacity decreases) per second.
@export var scale_start := Vector2(1.0, 1.0) # starting scale of the node, X and Y 
@export var scale_end := Vector2(0.5, 0.5) # final scale the node will shrink down to
@export var scale_speed := 1.0 # controls how fast the node scales down from scale_start to scale_end (seconds)

func _ready():
	if material:
		material = material.duplicate()
		shader_mat = material as ShaderMaterial
	
	if shader_mat:
		shader_mat.set_shader_parameter("fade", 1.0)
	
	scale = scale_start

func _process(delta):
	if shader_mat:
		var fade = shader_mat.get_shader_parameter("fade")
		fade = max(fade - fade_speed * delta, 0.0)
		shader_mat.set_shader_parameter("fade", fade)
		
		if fade <= 0.0:
			queue_free()
	
	scale = scale.lerp(scale_end, scale_speed * delta)


func update_label(damage_amount) -> void:
	$DamageNumberLabelBox/DamageNumberLabel.text = str(int(damage_amount)) if is_equal_approx(damage_amount, floor(damage_amount)) else str(damage_amount)

static func instantiate_scene() -> Node:
	var scene = preload("res://scenes/overlays/damage_number_label_container.tscn")
	return scene.instantiate()
