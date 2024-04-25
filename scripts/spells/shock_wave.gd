extends Node

@export var GROW_VALUE = 62.1
@export var SHAPE_FACTOR = 65.0
var parent_sprite = null
var parent_collision_shape = null

func _ready():
	parent_sprite = get_parent().get_node("Sprite2D")
	parent_collision_shape = get_parent().get_node("CollisionShape2D")
	pass

func _process(delta):
	parent_sprite.scale = parent_sprite.scale * GROW_VALUE * delta
	parent_collision_shape.scale = parent_collision_shape.scale * SHAPE_FACTOR * delta
