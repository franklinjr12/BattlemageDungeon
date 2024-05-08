extends Node2D

@onready var game = preload("res://scenes/game.tscn")
@onready var statistics_menu = preload("res://scenes/statistics_menu.tscn")

func _on_start_button_pressed():
	get_parent().call_deferred("add_child", game.instantiate())
	queue_free()

func _on_statistics_button_pressed():
	get_parent().call_deferred("add_child", statistics_menu.instantiate())
	queue_free()
