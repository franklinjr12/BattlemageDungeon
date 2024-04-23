extends Node

@onready var ensnare = preload("res://scenes/spells/effects/ensnare.tscn")

func on_body_entered(body : Node2D) -> void:
	if body is CharacterBody2D:
		var ensnare_inst = ensnare.instantiate()
		body.add_child(ensnare_inst)
