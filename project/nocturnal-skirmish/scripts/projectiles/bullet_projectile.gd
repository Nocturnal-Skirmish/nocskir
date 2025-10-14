extends BaseProjectile
class_name BulletProjectile

func _ready() -> void:
	projectile_damage = 2.5
	projectile_speed = 50
	pierce_amount = 100

# Function to instantiate self
static func instantiate_scene() -> Node:
	var scene = preload("res://scenes/projectiles/bullet_projectile.tscn")
	return scene.instantiate()
