extends Node2D

@export var dropped_experience : int = 1

const VELOCITY_MAG = 300
var velocity : Vector2 = Vector2.ONE
var direction : Vector2 = Vector2.ONE
var player : Player = null

func _ready():
	player = get_tree().root.get_node("Game/world/Player")
	direction = (player.position - position).normalized()

func _process(delta):
	direction = (player.position - position).normalized()
	position +=  direction * velocity * delta * VELOCITY_MAG


func _on_player_entered(body):
	if body is Player:
		body.gain_experience(dropped_experience)
		queue_free()

func set_dropped_experience(value : int):
	dropped_experience = value
