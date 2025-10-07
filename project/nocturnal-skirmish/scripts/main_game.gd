extends Node2D

@export var enemy_spawn_timer = 0.0
@export var enemy_spawn_interval = 3.0
@onready var EnemySlimeScene = preload("res://scenes/enemy_slime.tscn")
@onready var spawn_count = 0

func spawn_node_outside_viewport():
	var viewport = get_viewport()
	var spawn_pos = Vector2()
	var enemy_spawn_area = get_node("Player/Camera2D/EnemySpawnArea/CollisionShape2D").shape
	var x_range = (enemy_spawn_area.size.x - viewport.size.x) / 2
	var y_range = (enemy_spawn_area.size.y - viewport.size.y) / 2

	# Decide randomly which side outside the viewport to spawn (top, bottom, left, right)
	var side = randi() % 4

	match side:
		0: # Top side (above viewport)
			spawn_pos.x = randf_range(0, viewport.size.x)
			spawn_pos.y = randf_range(-y_range, 0)  # 100 pixels above the viewport
		1: # Bottom side (below viewport)
			spawn_pos.x = randf_range(0, viewport.size.x)
			spawn_pos.y = randf_range(viewport.size.y, viewport.size.y + y_range)  # 100 pixels below viewport
		2: # Left side (left of viewport)
			spawn_pos.x = randf_range(-x_range, 0)  # 100 pixels left of viewport
			spawn_pos.y = randf_range(0, viewport.size.y)
		3: # Right side (right of viewport)
			spawn_pos.x = randf_range(viewport.size.x, viewport.size.x + x_range)  # 100 pixels right of viewport
			spawn_pos.y = randf_range(0, viewport.size.y)

	var NewEnemy_node = EnemySlimeScene.instantiate()
	NewEnemy_node.position = spawn_pos
	
	spawn_count += 1
	NewEnemy_node.name = "%s_%d" % ["EnemySlime", spawn_count]
	print(str(spawn_pos) + " | " + NewEnemy_node.name)
	add_child(NewEnemy_node)

func _process(delta: float) -> void:
	enemy_spawn_timer -= delta
	if enemy_spawn_timer <= 0.0:
		spawn_node_outside_viewport()
		enemy_spawn_timer = enemy_spawn_interval
