extends Node2D

const DAMAGE : int = 60

func _ready():
	$AnimatedSprite2D.play('default')

func _on_animated_sprite_2d_animation_looped():
	queue_free()



func _on_area_2d_body_entered(body):
	if body.has_method("suffer_damage"):
		body.suffer_damage(DAMAGE)
