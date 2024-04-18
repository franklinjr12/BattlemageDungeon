extends Node2D

signal level_complete

@onready var player_reference = get_node("Player")
var game_over_scene = preload("res://scenes/game_over.tscn")
var enemies_count = 0
var enemies_list = Array()

func _ready():
	load_enemies_on_level()
	# get the number of enemies in the scene
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		enemy.enemy_died.connect(on_enemy_died)
	enemies_count = enemies.size()
	player_reference.player_died.connect(on_player_died)

func on_player_died():
	change_to_game_over()

func on_enemy_died():
	enemies_count -= 1
	if enemies_count <= 0:
		allow_exit_room()

func change_to_game_over():
	var game_over_scene_inst = game_over_scene.instantiate()
	get_tree().root.add_child(game_over_scene_inst)
	queue_free()

func load_enemies_on_level():
	const enemies_folder = "res://scenes/enemies/"
	# TODO need to find a better way for doing this
	enemies_list.append(load(enemies_folder + "rat.tscn"))
	enemies_list.append(load(enemies_folder + "bear.tscn"))
	enemies_list.append(load(enemies_folder + "creature1.tscn"))
	var arr_size = enemies_list.size()
	var enemies_spawn_area = get_tree().get_nodes_in_group("enemy_spawn")
	var num_enemies_to_spawn = randi_range(3,5)
	for i in num_enemies_to_spawn:
		var enemy_inst = enemies_list[randi_range(0,arr_size-1)].instantiate()
		var random_area = enemies_spawn_area.pick_random()
		enemies_spawn_area.erase(random_area)
		enemy_inst.position = random_area.position
		add_child(enemy_inst)
#	for area in enemies_spawn_area:
#		var enemy_inst = enemies_list[randi_range(0,arr_size-1)].instantiate()
#		enemy_inst.position = area.position
#		add_child(enemy_inst)

func allow_exit_room() -> void:
	var level_complete_label_node = get_node_or_null("LevelCompleteLabel")
	if level_complete_label_node:
		level_complete_label_node.get_parent().remove_child(level_complete_label_node)
		player_reference.get_node("Camera2D").add_child(level_complete_label_node)
		level_complete_label_node.visible = true
	var exit_area_node = get_node_or_null("ExitArea")
	if exit_area_node:
		exit_area_node.get_node("ColorRect").visible = true
		exit_area_node.body_entered.connect(on_player_exit_area)
	else:
		finish_level()

func on_player_exit_area(_body : Node2D) -> void:
	finish_level()

func finish_level() -> void:
	var level_complete_label_node = player_reference.get_node_or_null("Camera2D/LevelCompleteLabel")
	if level_complete_label_node:
		level_complete_label_node.get_parent().remove_child(level_complete_label_node)
		level_complete_label_node.queue_free()
	level_complete.emit()
