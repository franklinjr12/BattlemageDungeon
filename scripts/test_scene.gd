extends Node2D

@onready var player_reference = get_node("Player")
var game_over_scene = preload("res://scenes/game_over.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_reference.current_hp <= 0:
		var game_over_scene_inst = game_over_scene.instantiate()
		get_tree().root.add_child(game_over_scene_inst)
		queue_free()

