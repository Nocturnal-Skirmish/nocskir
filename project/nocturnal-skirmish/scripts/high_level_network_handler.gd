extends Node

const IP_ADDRESS: String = "localhost"
const PORT: int = 42069
const MAX_CLIENTS: int = 8

var peer: ENetMultiplayerPeer

func start_server() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	print("Server started on port", PORT)
	
	# Connect signals for peer join/leave
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)


func start_client() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
	print("Connected to server at", IP_ADDRESS, PORT)


func _on_peer_connected(id: int) -> void:
	print("Peer connected with ID:", id)
	# Optionally spawn a player if server
	if multiplayer.is_server():
		rpc_id(id, "spawn_player_remote", id)


func _on_peer_disconnected(id: int) -> void:
	print("Peer disconnected with ID:", id)
	# Optionally remove player instance
	var player = get_tree().get_root().find_node(str(id), true, false)
	if player:
		player.queue_free()
