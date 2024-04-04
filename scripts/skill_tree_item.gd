extends Node

@export var activated : bool = false
@export var light_attribute_required : int = 0 
@export var dark_attribute_required : int = 0 
@export var nature_attribute_required : int = 0 
@export var arcane_attribute_required : int = 0 
var player_reference : Player = null

func _ready():
	player_reference = get_parent().player_reference

func _process(_delta):
	if player_reference == null:
		player_reference = get_parent().player_reference
	if !activated and player_reference:
		var attributes : CharacterMagicalAttributes = player_reference.get_node("CharacterMagicalAttributes")
		if light_attribute_required <= attributes.light and dark_attribute_required <= attributes.dark and nature_attribute_required <= attributes.nature and arcane_attribute_required <= attributes.arcane:
			activated = true
	if activated:
		$ColorRect.visible = false
