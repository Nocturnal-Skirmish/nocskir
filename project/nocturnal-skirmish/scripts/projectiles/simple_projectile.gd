extends BaseProjectile
class_name SimpleProjectile

# Function to instantiate self
static func instantiate_scene() -> Node:
	var scene = preload("res://scenes/projectiles/simple_projectile.tscn")
	return scene.instantiate()
