class_name BaseSoulOrb
extends Node2D

@export var orb_scale: float = 2.0
@export var soul_amount: float = 1.0
@export var soul_orb_type: String = "Default"
@export var entity_type: String = "pickup"
@export var pickup_type: String = "soul_orb"
@export var pulled_by_magnet: bool = true

@onready var magnet_target: CharacterBody2D = null
@onready var magnet_speed: float = 10.0
@onready var magnet_speed_mult: float = 1.0

# Function to instantiate self
static func instantiate_scene() -> Node:
	var scene = preload("res://scenes/pickups/base_soul_orb.tscn")
	return scene.instantiate()

# Despawn after timeout
func _on_timer_timeout() -> void:
	queue_free()

func _ready() -> void:
	# Set scale to be correct
	scale = Vector2(scale[0] * orb_scale, scale[1] * orb_scale)

func pull_toward_target(delta: float) -> void:
	if magnet_target:
		var direction = (magnet_target.global_position - global_position).normalized()
		global_position += direction * (magnet_speed * magnet_speed_mult) * delta

func _process(delta: float) -> void:
	pull_toward_target(delta)
