extends Node

@export var network_player_scene: PackedScene
@export var spawn_path: NodePath = "."

func _ready() -> void:
	if multiplayer.is_server():
		multiplayer.peer_connected.connect(_on_peer_connected)


# Called by server when a new client joins
func _on_peer_connected(id: int) -> void:
	print("Spawning player for peer:", id)
	rpc_id(id, "spawn_player_remote", id)


# RPC to spawn player on clients
@rpc("any_peer")
func spawn_player_remote(id: int) -> void:
	# Avoid spawning twice
	for p in get_tree().get_nodes_in_group("player_list"):
		if p.name == str(id):
			return

	var player = network_player_scene.instantiate()
	player.name = str(id)

	# Only assign authority to local player
	if multiplayer.get_unique_id() == id:
		player.set_multiplayer_authority(id)
	else:
		# Remote copies have authority of the actual client
		player.set_multiplayer_authority(id)

	get_node(spawn_path).add_child(player)
	player.add_to_group("player_list")
	print("Player spawned:", player.name, "Authority:", player.get_multiplayer_authority())
