extends Node

@export var lifetime : float = 3
@export var slow_value : float = 0.5
@export var parent : Node2D = null
var parent_speed : float = 0

func _ready():
	parent = get_parent()
	parent_speed = float(parent.SPEED)
	parent.SPEED = parent_speed * slow_value
	$LifetimeTimer.wait_time = lifetime
	$LifetimeTimer.start()

func _process(_delta):
	pass

func _on_lifetime_timer_timeout():
	parent.SPEED = parent_speed
	queue_free()
