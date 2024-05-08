extends Node2D

@onready var game = preload("res://scenes/game.tscn")

func _on_start_button_pressed():
	get_parent().call_deferred("add_child", game.instantiate())

func _on_statistics_button_pressed():
	print("opening statistics")
