extends Node

func on_area_entered(area):
	if area is Spell:
		area.who_casted = get_parent().who_casted
		area.direction = -area.direction
		var norm = area.direction.normalized()
		area.rotate(atan2(norm.y,norm.x))
