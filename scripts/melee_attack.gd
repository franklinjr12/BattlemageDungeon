extends Area2D

var damage = 10

func _ready():
	pass

func _on_body_entered(body):
	if body is CharacterBody2D:
		body.suffer_damage(damage)
	queue_free()

func _on_timer_timeout():
	queue_free()
