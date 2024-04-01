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
		level_complete.emit()
		
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
	var enemies_spawn_area = get_tree().get_nodes_in_group("enemy_spawn")
	var arr_size = enemies_list.size()
	for area in enemies_spawn_area:
		var enemy_inst = enemies_list[randi_range(0,arr_size-1)].instantiate()
		enemy_inst.position = area.position
		add_child(enemy_inst)

