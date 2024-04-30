extends Node

class_name Statistics

class CurrentRunStatistic:
	var enemies_killed : int = 0
	var experience_gained : int = 0
	var levels_cleared : int = 0
	var total_combat_levels_time : int = 0
	var current_combat_levels_time : int = 0

@onready var current_run_statistic : CurrentRunStatistic = CurrentRunStatistic.new()

func _ready():
	get_parent().get_node("Player").connect("player_gained_experience", on_player_gained_experience)

func increment_current_levels():
	current_run_statistic.levels_cleared += 1
	print("levels cleared ", current_run_statistic.levels_cleared)

func on_player_gained_experience(value : int):
	current_run_statistic.experience_gained += value

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
