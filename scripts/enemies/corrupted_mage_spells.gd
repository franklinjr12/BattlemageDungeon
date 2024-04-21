extends Node

@onready var arrow = preload("res://scenes/spells/arrow.tscn")

func cast(pos : Vector2, dir : Vector2) -> float:
	var arrow_inst : Spell = arrow.instantiate()
	arrow_inst.position = pos
	arrow_inst.set_direction(dir)
	get_tree().root.add_child(arrow_inst)
	return arrow_inst.cooldown
