extends Node2D

signal level_complete

@onready var player_reference = get_node("Player")
var game_over_scene = preload("res://scenes/game_over.tscn")
var enemies_count = 0

func _ready():
	# get the number of enemies in the scene
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		enemy.enemy_died.connect(on_enemy_died)
	enemies_count = enemies.size()
	print("Have ", enemies_count, " in scene")
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
