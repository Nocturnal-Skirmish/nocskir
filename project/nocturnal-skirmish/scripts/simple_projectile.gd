extends Node2D

@export var projectile_speed = 300
@export var projectile_damage = 2
@export var pierce_amount = 1
@export var projectile_scale = 1
@export var projectile_size_mult = 1
@export var target_body: CharacterBody2D

@onready var target_pos = target_body.global_position
@onready var targets_hit = 0

func _process(delta: float) -> void:
	var direction = Vector2(cos(rotation), sin(rotation))
	position += direction * projectile_speed * delta

func _on_ready() -> void:
	rotation = (target_pos - global_position).angle()

func _on_hit_box_area_entered(area: Area2D) -> void:
	var enemy_body = area.get_parent()
	if "entity_type" in enemy_body and enemy_body["entity_type"] == "enemy":
		enemy_body.queue_free()
		print("Enemy hit")
		if targets_hit >= pierce_amount:
			queue_free()
		targets_hit += 1

func _on_timer_timeout() -> void:
	queue_free()
