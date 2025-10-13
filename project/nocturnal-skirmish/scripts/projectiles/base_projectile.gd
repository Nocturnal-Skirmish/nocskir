extends Node2D
class_name BaseProjectile

# Export vars
@export var projectile_speed: float = 300
@export var projectile_damage: float = 2.0
@export var pierce_amount = 1
@export var projectile_scale: float = 1.0
@export var target_body: Node2D
@export var target_entity_type: String = "enemy"

# On ready vars
@onready var hit_box = $HitBox
@onready var target_pos = target_body.global_position
@onready var targets_hit = 0

# Moves projectile towards a position
func move_to_direction(delta: float) -> void:
	var direction = Vector2(cos(rotation), sin(rotation))
	position += direction * projectile_speed * delta

# Points the projectile towards a target node
func point_to_target() -> float:
	var target_pos = target_body.global_position
	rotation = (target_pos - global_position).angle()
	return rotation

# Removes health from enemy that is hit by projectile
func hit_enemy_entity(hit_box: Area2D) -> void:
	var enemy_body = hit_box.get_parent()
	if "entity_type" in enemy_body and enemy_body["entity_type"] == target_entity_type:
		enemy_body["health_points"] -= projectile_damage
		enemy_body.damage_animation()
		if targets_hit >= pierce_amount:
			queue_free()
		targets_hit += 1

# Move toward target every frame
func _process(delta: float) -> void:
	move_to_direction(delta)

# Point towards target when projectile is spawned
func _on_ready() -> void:
	point_to_target()

# Handle collision with enemy
func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.name == "HitBox":
		hit_enemy_entity(area)

# Despawn after timeout
func _on_timer_timeout() -> void:
	queue_free()
