extends Node

var parent : Node2D = null
var fixed_position : Vector2 = Vector2.ZERO
@export var lifetime : float = 3

func _ready():
	parent = get_parent()
	fixed_position = parent.position
	$LifetimeTimer.wait_time = lifetime
	$LifetimeTimer.start()

func _process(_delta):
	if parent:
		if parent.is_on_floor():
			if fixed_position == Vector2.ZERO:
				fixed_position = parent.position
			parent.position = fixed_position

func _on_lifetime_timer_timeout():
	var sprite = parent.get_node_or_null("EnsnareSprite")
	if sprite:
		sprite.queue_free()
	queue_free()
