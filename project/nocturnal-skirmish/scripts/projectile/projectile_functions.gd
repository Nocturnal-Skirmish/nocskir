class_name ProjectileFunctions
extends Node

var bullet_projectile = preload("res://scenes/projectiles/bullet_projectile.tscn")
var simple_projectile = preload("res://scenes/projectiles/simple_projectile.tscn")

var projectile_spawn_count: int = 0
var projectile_timer: float = 0.0
var projectile_interval_default = 0.05

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

# Sends a projectile to closest enemy in range
func shoot_closest_enemy(
	range_area: CollisionShape2D,
	delta: float,
	projectile_parent,
	projectile_scene,
	enemies_in_range: Array[CharacterBody2D] = [],
	projectile_interval: float = projectile_interval_default
) -> void:
	if enemies_in_range.size() > 0:
		# Get global pos of entity who sent the projectile
		var global_position = projectile_parent.global_position
		# Get radius of area 2d collision shap for defining closest enemy
		var radius: float = range_area.shape.radius
		projectile_timer -= delta
		if projectile_timer <= 0.0:
			var closest_float: float = (radius * 2) + 100 # +100 to add some padding to closest enemy just in case
			var closest_enemy: CharacterBody2D
			# Selection sort
			for enemy in enemies_in_range:
				# Get distance from player
				var enemy_pos = enemy.global_position
				var player_pos = global_position
				var distance: float = enemy_pos.distance_to(player_pos)

				# See if its less than the current closest enemy
				if distance < closest_float:
					closest_float = distance
					closest_enemy = enemy

			#Send projectile towards enemy
			var projectile = projectile_scene.instantiate()
			projectile.global_position = global_position
			
			projectile_spawn_count += 1
			projectile.name = "%s%d" % [projectile.name, projectile_spawn_count]
			projectile.target_body = closest_enemy
			print(str(global_position) + " | " + projectile.name)
			projectile_parent.get_parent().add_child(projectile)
			projectile_timer = projectile_interval
