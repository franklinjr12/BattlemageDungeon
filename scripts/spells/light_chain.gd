extends Node

@onready var ensnare = preload("res://scenes/spells/effects/ensnare.tscn")
var ensnare_time : float = 3

func on_body_entered(body : Node2D) -> void:
	if body is CharacterBody2D:
		var body_chain : Sprite2D = get_parent().get_node("EnsnareSprite")
		body_chain.visible = true
		get_parent().remove_child(body_chain)
		var ensnare_inst = ensnare.instantiate()
		ensnare_inst.lifetime = ensnare_time
		var body_sprite = body.get_node_or_null("Sprite2D")
		if body_sprite:
			var wh = body_sprite.texture.get_size()
			body_chain.texture.get_image().resize(wh.x, wh.y)
		body.add_child(body_chain)
		body.add_child(ensnare_inst)
