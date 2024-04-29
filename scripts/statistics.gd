extends Node

class CurrentRunStatistic:
	var enemies_killed : int = 0
	var experience_gained : int = 0
	var levels_cleared : int = 0

@onready var current_run_statistic : CurrentRunStatistic = CurrentRunStatistic.new()

func _ready():
	get_parent().get_node("Player").connect("player_gained_experience", on_player_gained_experience)

func increment_current_levels():
	current_run_statistic.current_levels += 1

func on_player_gained_experience(value : int):
	current_run_statistic.experience_gained += value
