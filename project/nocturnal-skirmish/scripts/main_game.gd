extends Node2D

@export var camera_timer = 0.0
@export var camera_interval = 0.5
var camera_state = 3

var shader_enabled = false

@export var enemy_spawn_timer = 0.0
@export var enemy_spawn_interval = 5
@onready var EnemySlimeScene = preload("res://scenes/enemy_slime.tscn")
@onready var spawn_count = 0

func spawn_node_outside_viewport():
	var camera_max_view_area = get_node("Player/Camera2D/CameraMaxViewArea")
	var camera_max_view_area_shape = camera_max_view_area.get_node("CollisionShape2D").shape
	var spawn_range = 100.0 # Amount of pixels outside camera_max_view_area that enemy can spawn in
	
	var extents = camera_max_view_area_shape.extents
	var total_extents = extents + Vector2(spawn_range, spawn_range)
	var spawn_pos = Vector2.ZERO
	
	# Decide randomly which side outside the viewport to spawn (top, bottom, left, right)
	var side = randi_range(0, 3)
	
	match side:
		0: # Top side (above camera view)
			spawn_pos.x = randf_range(-total_extents.x, total_extents.x)
			spawn_pos.y = -extents.y - randf_range(0, spawn_range)
		1: # Bottom side (below camera view)
			spawn_pos.x = randf_range(-total_extents.x, total_extents.x)
			spawn_pos.y = extents.y - randf_range(0, spawn_range)
		2: # Left side (left of viewport)
			spawn_pos.x = -extents.x - randf_range(0, spawn_range)
			spawn_pos.y = randf_range(-total_extents.y, total_extents.y)
		3: # Right side (right of viewport)
			spawn_pos.x = extents.x - randf_range(0, spawn_range)
			spawn_pos.y = randf_range(-total_extents.y, total_extents.y)
			
	spawn_pos = camera_max_view_area.to_global(spawn_pos)
	
	var NewEnemy_node = EnemySlimeScene.instantiate()
	NewEnemy_node.global_position = spawn_pos
	
	spawn_count += 1
	NewEnemy_node.name = "%s%d" % ["EnemySlime", spawn_count]
	print(str(spawn_pos) + " | " + NewEnemy_node.name)
	add_child(NewEnemy_node)
	
func cycle_zoom():
	camera_state -= 1
	var MIN_ZOOM = Vector2(1.0, 1.0)
	var MAX_ZOOM = Vector2(3.0, 3.0)
	var zoom = get_node("Player/Camera2D").zoom
	var zoom_step = Vector2(1.0, 1.0)
	
		
	if camera_state == 0:
		camera_state = 3
		zoom = MAX_ZOOM
	else:
		zoom -= zoom_step
		if zoom > MAX_ZOOM:
			zoom = MIN_ZOOM
		elif zoom < MIN_ZOOM:
			zoom = MAX_ZOOM
	get_node("Player/Camera2D").zoom = zoom
	print("Zoom:", zoom)
	print(str(camera_timer) + str(camera_state))

func toggle_shader():
	if shader_enabled == true:
		%TileMap.material.set_shader_parameter("enabled", false)
		shader_enabled = false
	elif shader_enabled == false:
		%TileMap.material.set_shader_parameter("enabled", true)
		shader_enabled = true

func _process(delta: float) -> void:
	enemy_spawn_timer -= delta
	camera_timer -= delta
	
	if enemy_spawn_timer <= 0.0:
		spawn_node_outside_viewport()
		enemy_spawn_timer = enemy_spawn_interval
		
	if Input.is_key_pressed(KEY_C) and camera_timer <= 0.0:
		cycle_zoom()
		camera_timer = camera_interval
		
	if Input.is_key_pressed(KEY_P) and camera_timer <= 0.0:
		toggle_shader()
		camera_timer = camera_interval
	
	if Input.is_key_pressed(KEY_Q):
		spawn_node_outside_viewport()
