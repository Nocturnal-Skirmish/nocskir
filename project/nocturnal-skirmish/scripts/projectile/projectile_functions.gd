extends Node

# Includes function that are used in projectile nodes

# Moves the projectile towards a direction
func move_to_direction(
	projectile,
	projectile_speed: int,
	delta: float
) -> void:
	var direction = Vector2(cos(projectile.rotation), sin(projectile.rotation))
	projectile.position += direction * projectile_speed * delta

# Points the projectile towards a target node
func point_to_target(
	target,
	projectile
) -> float:
	var target_pos = target.global_position
	projectile.rotation = (target_pos - projectile.global_position).angle()
	return projectile.rotation

# Removes entity that is hit and also itself if pierce amount is less than or equal to targets hit
func remove_hit_entity(
	projectile,
	hit_box: Area2D,
	targets_hit: int,
	pierce_amount: int = 0,
	target_entity_type: String = "enemy",
) -> int:
	var enemy_body = hit_box.get_parent()
	if "entity_type" in enemy_body and enemy_body["entity_type"] == target_entity_type:
		enemy_body.queue_free()
		print("Enemy hit")
		if targets_hit >= pierce_amount:
			projectile.queue_free()
		targets_hit += 1
	return targets_hit
