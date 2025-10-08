extends CharacterBody2D

@export var speed = 200
@export var health_points = 100
@export var damage_interval = 0.5
@export var damage_timer = 0.0
@export var projectile_interval = 0.05
@export var projectile_timer = 0.0

@onready var player = $Sprite2D
@onready var enemies_in_hurtbox: Array[CharacterBody2D] = []
@onready var enemies_in_range: Array[CharacterBody2D] = []
@onready var SimpleProjectileScene = preload("res://scenes/simple_Projectile.tscn")
@onready var projectile_spawn_count = 0

func _process(delta):
	if enemies_in_hurtbox.size() > 0:
		damage_timer -= delta
		if damage_timer <= 0.0:
			player_take_damage()
			damage_timer = damage_interval
	
	var player_velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):
		player_velocity.y -= 1
	if Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):
		player_velocity.y += 1
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		player_velocity.x -= 1
		player.flip_h = true
	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		player_velocity.x += 1
		player.flip_h = false
	
	if Input.is_key_pressed(KEY_F):
		print(enemies_in_range)

	if player_velocity.length() > 0:
		player_velocity = player_velocity.normalized() * speed
		position += player_velocity * delta
	
	if enemies_in_range.size() > 0:
		projectile_timer -= delta
		if projectile_timer <= 0.0:
			var closest_float: float = 99999999.99
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
			var projectile = SimpleProjectileScene.instantiate()
			projectile.global_position = global_position
			
			projectile_spawn_count += 1
			projectile.name = "%s%d" % ["SimpleProjectile", projectile_spawn_count]
			projectile.target_body = closest_enemy
			print(str(global_position) + " | " + projectile.name)
			get_parent().add_child(projectile)
			projectile_timer = projectile_interval

func _on_hurt_box_area_entered(area: Area2D) -> void:
	var enemy_body = area.get_parent()
	if "entity_type" in enemy_body and enemy_body["entity_type"] == "enemy":
		enemies_in_hurtbox.append(enemy_body)

func _on_hurt_box_area_exited(area: Area2D) -> void:
	var enemy_body = area.get_parent()
	if "entity_type" in enemy_body and enemy_body["entity_type"] == "enemy":
		enemies_in_hurtbox.erase(enemy_body)

func player_take_damage():
	for enemy in enemies_in_hurtbox:
		if "damage_points" in enemy:
			health_points -= enemy["damage_points"]
			print("Damage taken! Damage: " + str(enemy["damage_points"]) + " | Health points: " + str(health_points))

			if health_points <= 0:
				get_tree().change_scene_to_file("res://scenes/game_ui.tscn")

func _on_range_area_entered(area: Area2D) -> void:
	var enemy_body = area.get_parent()
	if "entity_type" in enemy_body and enemy_body["entity_type"] == "enemy":
		enemies_in_range.append(enemy_body)

func _on_range_area_exited(area: Area2D) -> void:
	var enemy_body = area.get_parent()
	if "entity_type" in enemy_body and enemy_body["entity_type"] == "enemy":
		enemies_in_range.erase(enemy_body)
