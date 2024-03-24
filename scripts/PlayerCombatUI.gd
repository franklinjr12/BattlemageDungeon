extends Node2D

var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player == null:
		var running_scene = get_parent()
		if running_scene.name == "world":
			player = running_scene.get_node("Player")
	$PlayerHealthDisplay.value = player.current_hp
