extends Node

const DEFAULT_LEVEL_NAME = "world"
const LEVEL_UP_SCENE_NAME = "levelup"
const LEVELS_TO_LEVEL_UP_SCENE = 1

var player_reference = null
var scene_combat_script = preload("res://scripts/levels/combat_scene.gd")
var completed_levels = 0

func _ready():
	set_player_reference()
	set_level_name()
	connect_to_level_complete(DEFAULT_LEVEL_NAME)
	
func set_level_name():
	$TestScene.name = DEFAULT_LEVEL_NAME

func set_player_reference():
	player_reference = $TestScene/Player

func on_level_complete():
	var current_level = get_node_or_null(DEFAULT_LEVEL_NAME)
	if current_level == null:
		current_level = get_node_or_null(LEVEL_UP_SCENE_NAME)
	current_level.remove_child(player_reference)
	current_level.call_deferred("free")
	var new_level = null
	if completed_levels >= LEVELS_TO_LEVEL_UP_SCENE:
		completed_levels = 0
		new_level = create_levelup()
		new_level.name = LEVEL_UP_SCENE_NAME
	else:
		completed_levels += 1
		new_level = create_level()
		var player_spawn_position = new_level.get_node("PlayerSpawnArea").position
		player_reference.position = player_spawn_position
		new_level.name = DEFAULT_LEVEL_NAME
		new_level.set_script(scene_combat_script)
	new_level.add_child(player_reference)
	call_deferred("add_child", new_level)
	call_deferred("connect_to_level_complete", new_level.name)

func create_level() -> Node2D:
	# select one of the levels randomly
	var level_index = var_to_str(randi_range(1,2))
	var format_string = "res://scenes/levels/level_variant_%s.tscn"
	var actual_string = format_string % [level_index]
	print("chosen level ", actual_string)
	return load(actual_string).instantiate()

func connect_to_level_complete(level_name : String):
	get_node(level_name).level_complete.connect(on_level_complete)

func create_levelup() -> Node2D:
	return load("res://scenes/level_up_scene.tscn").instantiate()
