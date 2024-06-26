extends Node

const DEFAULT_LEVEL_NAME = "world"
const LEVEL_UP_SCENE_NAME = "levelup"
const LEVELS_TO_LEVEL_UP_SCENE = 3

var player_reference = null
var scene_combat_script = preload("res://scripts/levels/combat_scene.gd")
var completed_levels = 1
var statistics : Statistics = null

func _ready():
	set_player_reference()
	var level = create_level()
	remove_child(player_reference)
	level.add_child(player_reference)
	level.name = DEFAULT_LEVEL_NAME
	level.set_script(scene_combat_script)
	var player_spawn_position = level.get_node("PlayerSpawnArea").position
	player_reference.position = player_spawn_position
	add_child(level)
	$CombatLevelTimer.start()
	connect_to_level_complete(DEFAULT_LEVEL_NAME)
	statistics = get_node("Statistics")
	statistics.connect_to_enemies_died_signal()
	statistics.load_global_statistic()

func set_player_reference():
	player_reference = $Player

func on_level_complete():
	statistics.clear_current_combat_levels_time()
	$CombatLevelTimer.stop()
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
		get_node("Statistics").increment_current_levels()
		completed_levels += 1
		new_level = create_level()
		var player_spawn_position = new_level.get_node("PlayerSpawnArea").position
		player_reference.position = player_spawn_position
		new_level.name = DEFAULT_LEVEL_NAME
		new_level.set_script(scene_combat_script)
		$CombatLevelTimer.start()
	new_level.add_child(player_reference)
	call_deferred("add_child", new_level)
	call_deferred("connect_to_level_complete", new_level.name)
	get_node("Statistics").call_deferred("connect_to_enemies_died_signal")

func create_level() -> Node2D:
	# select one of the levels randomly
	var level_index = var_to_str(randi_range(1,5))
	var format_string = "res://scenes/levels/level_variant_%s.tscn"
	var actual_string = format_string % [level_index]
	print("chosen level ", actual_string)
	return load(actual_string).instantiate()
#	return load("res://scenes/levels/level_variant_0.tscn").instantiate() # test level

func connect_to_level_complete(level_name : String):
	get_node(level_name).level_complete.connect(on_level_complete)

func create_levelup() -> Node2D:
	return load("res://scenes/level_up_scene.tscn").instantiate()

func assign_random_spell_to_player():
	# test assigning spells
	var spell = load("res://scenes/spells/spell.tscn")
	var fireball = load("res://scenes/spells/fireball.tscn")
	var arrow = load("res://scenes/spells/arrow.tscn")
	var bolt = load("res://scenes/spells/bolt.tscn")
	var spells = [spell, fireball, arrow, bolt]
	var ps = player_reference.get_node("Camera2D/PlayerCombatUI").get_node("PlayerPreparedSpellsUI")
	var s = null
	s = spells[randi_range(0,3)]
	player_reference.spell_1 = s
	ps.assign_new_spell_to_slot(s.instantiate(), 1)
	s = spells[randi_range(0,3)]
	player_reference.spell_2 = s
	ps.assign_new_spell_to_slot(s.instantiate(), 2)
	s = spells[randi_range(0,3)]
	player_reference.spell_3 = s
	ps.assign_new_spell_to_slot(s.instantiate(), 3)
	s = spells[randi_range(0,3)]
	player_reference.spell_4 = s
	ps.assign_new_spell_to_slot(s.instantiate(), 4)

func _on_combat_level_timer_timeout():
	statistics.increment_current_combat_levels_time()
	statistics.increment_total_combat_levels_time()
