extends Node

func on_body_entered(body):
	if body is Spell:
		body.direction = -body.direction
		var norm = body.direction.normalized()
		body.rotate(atan2(norm.y,norm.x))
