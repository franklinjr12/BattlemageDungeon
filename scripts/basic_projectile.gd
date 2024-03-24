extends Area2D

@export var VELOCITY_MAG = 200
var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	position += velocity * delta



func _on_body_entered(body):
	if body is StaticBody2D:
		print("collided with floor or wall")
	elif body is CharacterBody2D:
		print("collided with character")
	queue_free()
