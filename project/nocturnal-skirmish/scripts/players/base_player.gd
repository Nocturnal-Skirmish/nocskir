extends CharacterBody2D
class_name BasePlayer

@export var player_name: String = "PlayerMan"
@export var character_name: String = "DefaultMan"
@export var speed: int = 200
@export var health_points: float = 100
@export var soul_orb_amount: float = 0
@export var soul_orb_level = 0
@export var soul_orb_gain_mult = 1
@export var damage_interval = 0.5
@export var damage_timer = 0.0
@export var magnet_speed_mult: float = 5.0

@onready var player_sprite = $AnimatedSprite2D
@onready var enemies_in_hurtbox: Array[CharacterBody2D] = []
@onready var enemies_in_range: Array[CharacterBody2D] = []
@onready var projectile_functions = ProjectileFunctions.new()
@onready var SimpleProjectileScene = SimpleProjectile.new()
@onready var BulletProjectileScene = BulletProjectile.new()
@onready var range_area = get_node("RangeArea/CollisionShape2D")
@onready var soul_orb_amount_label = $Camera2D/HUDCanvas/ControlsUI/TopRightUi/MarginContainer/SoulOrbAmountLabel

@export var entity_type = "player"

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
		player_sprite.flip_h = false
	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		player_velocity.x += 1
		player_sprite.flip_h = true
	
	if Input.is_key_pressed(KEY_F):
		print(enemies_in_range)

	if player_velocity.length() > 0:
		player_velocity = player_velocity.normalized() * speed
		position += player_velocity * delta

	projectile_functions.shoot_closest_enemy(
		range_area, # Range of player
		delta,
		self, # Player node
		SimpleProjectileScene.instantiate_scene(), # Projectile scene to be sent
		enemies_in_range, # List of enemies in range area
		0.5 # Projectile shoot interval
	)
	projectile_functions.shoot_closest_enemy(
		range_area, # Range of player
		delta,
		self, # Player node
		BulletProjectileScene.instantiate_scene(), # Projectile scene to be sent
		enemies_in_range, # List of enemies in range area
		0.5 # Projectile shoot interval
	)

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.name == "HitBox":
		var enemy_body = area.get_parent()
		if "entity_type" in enemy_body and enemy_body["entity_type"] == "enemy":
			enemies_in_hurtbox.append(enemy_body)

func _on_hurt_box_area_exited(area: Area2D) -> void:
	if area.name == "HitBox":
		var enemy_body = area.get_parent()
		if "entity_type" in enemy_body and enemy_body["entity_type"] == "enemy":
			enemies_in_hurtbox.erase(enemy_body)

func player_take_damage():
	for enemy in enemies_in_hurtbox:
		if "damage_points" in enemy:
			health_points -= enemy["damage_points"]
			print("Damage taken! Damage: " + str(enemy["damage_points"]) + " | Health points: " + str(health_points))
			var health_bar = get_node("Camera2D/HUDCanvas/ControlsUI/BottomLeftUi/TextureProgressBar")
			health_bar.value = health_points

			if health_points <= 0:
				get_tree().change_scene_to_file("res://scenes/game_ui.tscn")

func _on_range_area_entered(area: Area2D) -> void:
	if area.name == "HitBox":
		var enemy_body = area.get_parent()
		if "entity_type" in enemy_body and enemy_body["entity_type"] == "enemy":
			enemies_in_range.append(enemy_body)

func _on_range_area_exited(area: Area2D) -> void:
	if area.name == "HitBox":
		var enemy_body = area.get_parent()
		if "entity_type" in enemy_body and enemy_body["entity_type"] == "enemy":
			enemies_in_range.erase(enemy_body)

# Updates label with soul orb amount
func update_soul_orb_label() -> void:
	soul_orb_amount_label.text = "Soul Orb Amount: %s" % [soul_orb_amount]

# add self to player list group
func _on_ready() -> void:
	add_to_group("player_list")
	var players = get_tree().get_nodes_in_group("player_list")
	print(players)
	
	$AnimatedSprite2D/PlayerNameLabel.text = player_name

# When pickup is in range
func _on_pickup_range_area_entered(area: Area2D) -> void:
	var pickup = area.get_parent()
	if "entity_type" in pickup and pickup["entity_type"] == "pickup" and "pickup_type" in pickup:
		match pickup["pickup_type"]:
			"soul_orb":
				soul_orb_amount += (pickup["soul_amount"] * soul_orb_gain_mult)
				update_soul_orb_label()
				pickup.queue_free()

func _on_pickup_magnet_range_area_entered(area: Area2D) -> void:
	var pickup = area.get_parent()
	if "entity_type" in pickup and pickup["entity_type"] == "pickup" and pickup["pulled_by_magnet"]:
		pickup["magnet_speed_mult"] = magnet_speed_mult
		pickup["magnet_target"] = self


func _on_pickup_magnet_range_area_exited(area: Area2D) -> void:
	var pickup = area.get_parent()
	if "entity_type" in pickup and pickup["entity_type"] == "pickup" and pickup["pulled_by_magnet"]:
		pickup["magnet_speed_mult"] = 1.0
		pickup["magnet_target"] = null
