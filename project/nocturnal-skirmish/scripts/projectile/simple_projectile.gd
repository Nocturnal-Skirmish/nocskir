extends Node2D

@onready var projectile_functions_script = preload("res://scripts/projectile/projectile_functions.gd").new()
@export var projectile_speed = 300
@export var projectile_damage = 2
@export var pierce_amount = 1
@export var projectile_scale = 1
@export var projectile_size_mult = 1
@export var target_body: CharacterBody2D

@onready var target_pos = target_body.global_position
@onready var targets_hit = 0

# Move toward target every frame
func _process(delta: float) -> void:
	projectile_functions_script.move_to_direction(self, projectile_speed, delta)

# Point towards target when projectile is spawned
func _on_ready() -> void:
	projectile_functions_script.point_to_target(target_body, self)

# Handle collision with enemy
func _on_hit_box_area_entered(area: Area2D) -> void:
	targets_hit = projectile_functions_script.remove_hit_entity(
		self,
		area,
		targets_hit,
		pierce_amount
	)

func _on_timer_timeout() -> void:
	queue_free()
