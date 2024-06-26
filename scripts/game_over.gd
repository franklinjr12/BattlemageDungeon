extends Node2D

@onready var game = preload("res://scenes/game.tscn")

func _ready():
	var statistics : Statistics = get_parent().get_node("Statistics")
	statistics.save_global_statistic()
	$Control/VBoxContainer/HBoxContainer/KillsValue.text = var_to_str(statistics.get_current_run_kills())
	$Control/VBoxContainer/HBoxContainer2/MaxCharacterLevelValue.text = var_to_str(statistics.get_current_run_max_character_level())
	$Control/VBoxContainer/HBoxContainer3/LevelsClearedValue.text = var_to_str(statistics.get_current_run_levels_cleared())
	$Control/VBoxContainer/HBoxContainer4/TotalExpValue.text = var_to_str(statistics.get_current_run_experience_gained())
	$Control/VBoxContainer/HBoxContainer5/CombatTimeValue.text = var_to_str(statistics.get_current_run_combat_time())

	$GlobalStatistic/VBoxContainer/HBoxContainer/KillsValue.text = var_to_str(statistics.global_statistic.enemies_killed)
	$GlobalStatistic/VBoxContainer/HBoxContainer2/MaxCharacterLevelValue.text = var_to_str(statistics.global_statistic.player_level)
	$GlobalStatistic/VBoxContainer/HBoxContainer3/LevelsClearedValue.text = var_to_str(statistics.global_statistic.levels_cleared)
	$GlobalStatistic/VBoxContainer/HBoxContainer4/TotalExpValue.text = var_to_str(statistics.global_statistic.experience_gained)
	$GlobalStatistic/VBoxContainer/HBoxContainer5/CombatTimeValue.text = var_to_str(statistics.global_statistic.total_combat_levels_time)

func _on_start_button_pressed():
	get_parent().call_deferred("add_child", game.instantiate())
	queue_free()
