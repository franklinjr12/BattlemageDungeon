extends Node

var dps = preload("res://scenes/spells/effects/dps.tscn")

const ticks_per_second : int = 3

func on_body_entered(body):
	if body is CharacterBody2D:
		var new_dps : DPS = dps.instantiate()
		var parent : Spell = get_parent()
		new_dps.ticks_per_sec = ticks_per_second
		new_dps.damage_per_tick = parent.damage
		new_dps.lifetime = parent.cooldown
		body.add_child(new_dps)
