extends Node
# Script to send a projectile to the closest enemy inside of projectile range.

@onready var projectile_spawn_count: int = 0
@onready var projectile_timer: float = 0.0
@export var projectile_interval_default = 0.05

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
				var distance = enemy_pos.distance_to(player_pos)

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
