extends Node

const DEFAULT_LEVEL_NAME = "world"

var player_reference = null
var scene_combat_script = preload("res://scripts/levels/combat_scene.gd")

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
	new_level.add_child(player_reference)
	new_level.name = DEFAULT_LEVEL_NAME
	new_level.set_script(scene_combat_script)
	call_deferred("add_child", new_level)
	call_deferred("connect_to_level_complete")

func create_level() -> Node2D:
	# select one of the levels randomly
	var level_index = var_to_str(randi_range(1,2))
	var format_string = "res://scenes/levels/level_variant_%s.tscn"
	var actual_string = format_string % [level_index]
	print("chosen level ", actual_string)
	return load(actual_string).instantiate()

func connect_to_level_complete():
	get_node(DEFAULT_LEVEL_NAME).level_complete.connect(on_level_complete)
