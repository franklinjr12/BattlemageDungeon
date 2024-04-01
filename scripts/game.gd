extends Node

const DEFAULT_LEVEL_NAME = "world"

var player_reference = null

func _ready():
	set_player_reference()
	set_level_name()
	connect_to_level_complete()
	
func set_level_name():
	$TestScene.name = DEFAULT_LEVEL_NAME

func set_player_reference():
	player_reference = $TestScene/Player

func on_level_complete():
	var current_level = get_node(DEFAULT_LEVEL_NAME)
	current_level.remove_child(player_reference)
	current_level.call_deferred("free")
	#current_level.queue_free()
	var new_level = create_level()
	var player_spawn_position = new_level.get_node("PlayerSpawnArea").position
	player_reference.position = player_spawn_position
	print("adding player")
	new_level.add_child(player_reference)
	new_level.name = DEFAULT_LEVEL_NAME
	call_deferred("add_child", new_level)

func create_level() -> Node2D:
	return load("res://scenes/levels/level_variant_1.tscn").instantiate()

func connect_to_level_complete():
	get_node(DEFAULT_LEVEL_NAME).level_complete.connect(on_level_complete)
