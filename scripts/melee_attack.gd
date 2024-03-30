extends Area2D

var damage = 10
var damage_number = preload("res://scenes/damage_number.tscn")

func _ready():
	pass

func _on_body_entered(body):
	if body is CharacterBody2D:
		body.suffer_damage(damage)
		var new_damage_number = damage_number.instantiate()
		new_damage_number.position = position
		new_damage_number.text = var_to_str(damage)
		get_parent().add_child(new_damage_number)
	queue_free()

func _on_timer_timeout():
	queue_free()
