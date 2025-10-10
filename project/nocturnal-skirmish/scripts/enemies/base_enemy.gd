class_name BaseEnemy
extends CharacterBody2D

@export var health_points: float = 1.0
@export var enemy_speed: float = 50.0
@export var damage_points: float = 5.0
@export var entity_type: String = "enemy"
@export var enemy_type: String
@export var soul_orb_drop_value: float = 1.0

@onready var players_in_chase_range: Array[CharacterBody2D]
@onready var players_in_detection_range: Array[CharacterBody2D]
@onready var chase_range_area: Area2D = $ChaseRange
@onready var detection_area: Area2D = $DetectionRange
@onready var current_target: CharacterBody2D
@onready var random_player_target: bool = false
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Sorts closest player out of a list of players
func sort_closest(
	players_array: Array[CharacterBody2D],
	range_area: Area2D
) -> CharacterBody2D:
	# There are players in range, get closest
	var radius: float = range_area.shape.radius
	var closest_float: float = (radius * 2) + 100 # +100 to add some padding to closest player just in case
	var closest_player: CharacterBody2D
	# Selection sort
	for player in players_array:
		# Get distance from player
		var player_pos = player.global_position
		var enemy_pos = global_position
		var distance = enemy_pos.distance_to(player_pos)

		# See if its less than the current closest player
		if distance < closest_float:
			closest_float = distance
			closest_player = player
	return closest_player

# Chases a player
func chase():
	if current_target:
		# Go towards current target
		var direction = global_position.direction_to(current_target.global_position)
		velocity = direction * enemy_speed
		
		if velocity.x > 0:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
		
		move_and_slide()

func _on_chase_range_area_entered(area: Area2D) -> void:
	if area.name == "HitBox":
		# get entity in range
		var entity = area.get_parent()
		# Check if entity is any player
		if "entity_type" in entity and entity.entity_type == "player":
			players_in_chase_range.append(entity)
			print("Player %s added to players in chase range" % [entity])

func _on_chase_range_area_exited(area: Area2D) -> void:
	if area.name == "HitBox":
		# get entity in range
		var entity = area.get_parent()
		# Check if entity is any player
		if "entity_type" in entity and entity.entity_type == "player":
			players_in_chase_range.erase(entity)
			print("Player %s removed from players in chase range" % [entity])

func _on_detection_range_area_entered(area: Area2D) -> void:
	if area.name == "HitBox":
		# get entity in range
		var entity = area.get_parent()
		# Check if entity is any player
		if "entity_type" in entity and entity.entity_type == "player":
			players_in_detection_range.append(entity)
			print("Player %s added to players in detection range" % [entity])

func _on_detection_range_area_exited(area: Area2D) -> void:
	if area.name == "HitBox":
		# get entity in range
		var entity = area.get_parent()
		# Check if entity is any player
		if "entity_type" in entity and entity.entity_type == "player":
			players_in_detection_range.erase(entity)
			print("Player %s removed from players in detection range" % [entity])

func get_closest() -> void:
	if players_in_chase_range.size() > 0:
		random_player_target = false
		# Check detection range first
		if players_in_detection_range.size() > 0:
			var closest_player_in_detection: CharacterBody2D = sort_closest(
				players_in_detection_range,
				detection_area
			)
			current_target = closest_player_in_detection
		else:
			# no one in detection, check range
			var closest_player_in_chase: CharacterBody2D = sort_closest(
				players_in_chase_range,
				chase_range_area,
			)
			if current_target != closest_player_in_chase:
				# Check if current target is in chase range
				if current_target not in players_in_chase_range:
					current_target = closest_player_in_chase
	else:
		# No players in range, get random player if not already going to random player
		if random_player_target == false:
			var player_list = get_tree().get_nodes_in_group("player_list")
			var random_index = randi() % player_list.size()
			current_target = player_list[random_index]
			random_player_target = true

func _ready() -> void:
	get_closest()

func _on_sort_closest_cooldown_timeout() -> void:
	get_closest()

# Chase loop and stop on H
func _process(delta: float) -> void:
	# Temporary input
	if not Input.is_key_pressed(KEY_H):
		chase()
