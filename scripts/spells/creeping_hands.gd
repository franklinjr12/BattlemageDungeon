extends Node

@onready var slow = preload("res://scenes/spells/effects/slow.tscn")
@export var slow_value = 0.2
var parent : Spell = null

func _ready():
	parent = get_parent()
	if !parent.who_casted.is_on_floor():
		parent.who_casted.reset_spell_cooldown()
		parent.queue_free()
	if parent.who_casted.position.x > parent.position.x:
		parent.get_node("Sprite2D").flip_h = true

func _process(_delta):
	pass

func on_body_entered(body : Node2D):
	if body is CharacterBody2D:
		var new_slow = slow.instantiate()
		new_slow.slow_value = slow_value
		new_slow.lifetime = float(parent.lifetime) / 2
		body.add_child(new_slow)
