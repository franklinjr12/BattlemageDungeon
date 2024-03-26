extends Area2D

const DAMAGE = 10
const COOLDOWN = 0.5

func _ready():
	pass

func _process(delta):
	pass

func _on_body_entered(body):
	if body is CharacterBody2D:
		print("attack hit the player")
		body.suffer_damage(DAMAGE)
	queue_free()

func _on_timer_timeout():
	print("attack timeout")
	queue_free()
