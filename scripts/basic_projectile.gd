extends Area2D

@export var VELOCITY_MAG = 200

var damage_number = preload("res://scenes/damage_number.tscn")

const damage = 50
var velocity = Vector2.ZERO
var who_casted = null

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
			body.suffer_damage(damage)
			var new_damage_number = damage_number.instantiate()
			new_damage_number.position = position
			new_damage_number.text = var_to_str(damage)
			get_parent().add_child(new_damage_number)
	queue_free()
