extends Node

func _ready():
	var parent : Spell = get_parent()
	if !parent.who_casted.is_on_floor():
		parent.who_casted.reset_spell_cooldown()
		parent.queue_free()
	if parent.who_casted.position.x > parent.position.x:
		parent.get_node("Sprite2D").flip_h = true

#func _process(_delta):
#	var parent : Spell = get_parent()
#	if parent.who_casted.position.x > parent.position.x:
#		parent.get_node("Sprite2D").flip_h = true
