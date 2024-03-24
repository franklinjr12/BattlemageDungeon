extends Area2D

@export var VELOCITY_MAG = 200
var velocity = Vector2.ZERO

const damage = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	position += velocity * delta



func _on_body_entered(body):
	if body is StaticBody2D:
		print("collided with floor or wall")
	elif body is CharacterBody2D:
		var health_bar = body.get_node_or_null("HealthBar")
		if health_bar:
			health_bar.value -= damage
	queue_free()
