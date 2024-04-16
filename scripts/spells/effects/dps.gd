extends Node

class_name DPS

@export var ticks_per_sec : int = 1
@export var damage_per_tick : int = 1
@export var lifetime : float = 1

func _ready():
	$DamageTimer.wait_time = 1.0 / ticks_per_sec
	$LifetimeTimer.wait_time = lifetime
	$DamageTimer.start()
	$LifetimeTimer.start()



func _on_lifetime_timer_timeout():
	queue_free()


func _on_damage_timer_timeout():
	get_parent().suffer_damage(damage_per_tick)
