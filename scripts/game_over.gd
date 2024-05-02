extends Node2D

func _ready():
	var statistics : Statistics = get_parent().get_node("Statistics")
	$Control/VBoxContainer/HBoxContainer/KillsValue.text = var_to_str(statistics.get_current_run_kills())
	$Control/VBoxContainer/HBoxContainer2/MaxCharacterLevelValue.text = var_to_str(statistics.get_current_run_max_character_level())
	$Control/VBoxContainer/HBoxContainer3/LevelsClearedValue.text = var_to_str(statistics.get_current_run_levels_cleared())
	$Control/VBoxContainer/HBoxContainer4/TotalExpValue.text = var_to_str(statistics.get_current_run_experience_gained())
	$Control/VBoxContainer/HBoxContainer5/CombatTimeValue.text = var_to_str(statistics.get_current_run_combat_time())
