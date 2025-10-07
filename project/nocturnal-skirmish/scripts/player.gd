extends CharacterBody2D

@export var speed = 200
@export var health_points = 100
@export var enemies_in_hurtbox: Array[CharacterBody2D] = []
@export var damage_interval = 0.5
@export var damage_timer = 0.0

@onready var player = $Sprite2D
@onready var hurt_box_entered = false


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
		print(enemies_in_hurtbox)

	if player_velocity.length() > 0:
		player_velocity = player_velocity.normalized() * speed
		position += player_velocity * delta

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
			print("Damage taken! Damage: " + str(enemy["damage_points"]) + " | Health points: " + str(health_points))
			health_points -= enemy["damage_points"]

			if health_points <= 0:
				get_tree().change_scene_to_file("res://scenes/game_ui.tscn")
