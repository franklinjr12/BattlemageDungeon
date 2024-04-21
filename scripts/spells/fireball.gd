extends Node

@onready var fire_explosion = preload("res://scenes/effects/fire_explosion.tscn")

func _ready():
	get_parent().destroyed.connect(on_parent_destroyed)

func on_parent_destroyed(pos):
	var fire_explosion_inst = fire_explosion.instantiate()
	fire_explosion_inst.position = pos
	get_tree().root.call_deferred("add_child", fire_explosion_inst)
