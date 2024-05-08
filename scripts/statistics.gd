extends Node

class_name Statistics

class CurrentRunStatistic:
	var enemies_killed : int = 0
	var experience_gained : int = 0
	var player_level : int = 0
	var levels_cleared : int = 0
	var total_combat_levels_time : int = 0
	var current_combat_levels_time : int = 0

@onready var current_run_statistic : CurrentRunStatistic = CurrentRunStatistic.new()

class GlobalStatistic:
	var enemies_killed : int = 0
	var experience_gained : int = 0
	var player_level : int = 0
	var levels_cleared : int = 0
	var total_combat_levels_time : int = 0
	
	func to_save_file() -> String:
		return "%d %d %d %d %d" % [enemies_killed, experience_gained, player_level, levels_cleared, total_combat_levels_time]

	func from_save_file(serialized_data : String) -> void:
		var arr = serialized_data.split(" ")
		enemies_killed = int(arr[0])
		experience_gained = int(arr[1])
		player_level = int(arr[2])
		levels_cleared = int(arr[3])
		total_combat_levels_time = int(arr[4])

@onready var global_statistic : GlobalStatistic = GlobalStatistic.new()

const save_file : String = "user://battlemage.save"

func _ready():
	var parent = get_parent()
	if parent.name == "world":
		parent.get_node("Player").connect("player_gained_experience", on_player_gained_experience)
		parent.get_node("Player").connect("leveled_up", on_player_leveled_up)

func increment_current_levels():
	current_run_statistic.levels_cleared += 1
	print("levels cleared ", current_run_statistic.levels_cleared)

func on_player_gained_experience(value : int):
	current_run_statistic.experience_gained += value

func on_player_leveled_up():
	current_run_statistic.player_level += 1

func connect_to_enemies_died_signal():
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		enemy.enemy_died.connect(on_enemy_died)

func on_enemy_died():
	current_run_statistic.enemies_killed += 1
#	print("current enemies killed ", current_run_statistic.enemies_killed)

func increment_total_combat_levels_time():
	current_run_statistic.total_combat_levels_time += 1
#	print("total_combat_levels_time ", current_run_statistic.total_combat_levels_time)

func clear_current_combat_levels_time():
	current_run_statistic.current_combat_levels_time = 0

func increment_current_combat_levels_time():
	current_run_statistic.current_combat_levels_time += 1
#	print("current_combat_levels_time ", current_run_statistic.current_combat_levels_time)

func get_current_run_kills() -> int:
	return current_run_statistic.enemies_killed

func get_current_run_levels_cleared() -> int:
	return current_run_statistic.levels_cleared

func get_current_run_max_character_level() -> int:
	return current_run_statistic.player_level

func get_current_run_experience_gained() -> int:
	return current_run_statistic.experience_gained

func get_current_run_combat_time() -> int:
	return current_run_statistic.total_combat_levels_time

func load_global_statistic() -> void:
	if not FileAccess.file_exists(save_file):
		return
	var save_game = FileAccess.open(save_file, FileAccess.READ)
	var serialized_data : String = save_game.get_line()
	print("serialized_class: ", serialized_data)
	global_statistic.from_save_file(serialized_data)

func save_global_statistic() -> void:
	global_statistic.enemies_killed += current_run_statistic.enemies_killed
	global_statistic.experience_gained += current_run_statistic.experience_gained
	global_statistic.levels_cleared += current_run_statistic.levels_cleared
	global_statistic.total_combat_levels_time += current_run_statistic.total_combat_levels_time
	if current_run_statistic.player_level > global_statistic.player_level:
		global_statistic.player_level = current_run_statistic.player_level
	print(global_statistic.to_save_file())
	var save_game = FileAccess.open(save_file, FileAccess.WRITE)
	save_game.store_string(global_statistic.to_save_file())
	save_game.close()
