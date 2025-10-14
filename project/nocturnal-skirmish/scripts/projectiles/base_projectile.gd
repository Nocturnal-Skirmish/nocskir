extends Node2D
class_name BaseProjectile

# Export vars
@export var projectile_speed: float = 300
@export var projectile_damage: float = 2.0
@export var pierce_amount: int = 0
@export var projectile_scale: float = 1.0
@export var target_body: Node2D
@export var target_entity_type: String = "enemy"

# On ready vars
@onready var hit_box: Area2D = $HitBox
@onready var projectile_hit_sound_effect: AudioStreamPlayer2D = $ProjectileHitSoundEffect
@onready var pierce_sound_effect: AudioStreamPlayer2D = $PierceSoundEffect
@onready var target_pos: Vector2 = target_body.global_position
@onready var targets_hit: int = 0

func play_audio(
	audio_file: AudioStreamPlayer2D,
	random_pitch: bool = false
):
	if random_pitch:
		audio_file.pitch_scale = randf_range(0.90, 1.05)
	audio_file.play()
	await audio_file.finished

# Moves projectile towards a position
func move_to_direction(delta: float) -> void:
	var direction = Vector2(cos(rotation), sin(rotation))
	position += direction * projectile_speed * delta

# Points the projectile towards a target node
func point_to_target() -> float:
	var target_pos = target_body.global_position
	rotation = (target_pos - global_position).angle()
	return rotation

# Removes health from enemy that is hit by projectile
func hit_enemy_entity(hit_box: Area2D) -> void:
	var enemy_body = hit_box.get_parent()
	if "entity_type" in enemy_body and enemy_body["entity_type"] == target_entity_type:
		enemy_body["health_points"] -= projectile_damage
		enemy_body.damage_animation()
		enemy_body.show_damage_number_on_hit(projectile_damage)
		await play_audio(projectile_hit_sound_effect)
		if targets_hit >= pierce_amount:
			queue_free()
		else:
			await play_audio(pierce_sound_effect, true)
		targets_hit += 1

# Move toward target every frame
func _process(delta: float) -> void:
	move_to_direction(delta)

# Point towards target when projectile is spawned
func _on_ready() -> void:
	point_to_target()

# Handle collision with enemy
func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.name == "HitBox":
		hit_enemy_entity(area)

# Despawn after timeout
func _on_timer_timeout() -> void:
	queue_free()
