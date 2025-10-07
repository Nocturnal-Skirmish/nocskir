extends CharacterBody2D

@onready var player = get_node("../Player")
@export var speed = 40
@export var health_points = 10
@export var damage_points = 5
@export var entity_type = "enemy"
@export var enemy_type = "small_enemy"

func chase():
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	
	move_and_slide()

func _process(delta):
	
	if not Input.is_key_pressed(KEY_C):
		chase()
