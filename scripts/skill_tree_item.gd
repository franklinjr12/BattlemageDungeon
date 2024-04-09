extends Node

@export var activated : bool = false
@export var light_attribute_required : int = 0 
@export var dark_attribute_required : int = 0 
@export var nature_attribute_required : int = 0 
@export var arcane_attribute_required : int = 0 
@export var spell : PackedScene
var player_reference : Player = null
var current_player_spell = 0

func _ready():
	player_reference = get_parent().player_reference
	if spell != null:
		const slots_size = Vector2(40,40)
		var img = spell.instantiate().get_node("Sprite2D").texture.get_image().duplicate()
		img.resize(slots_size.x, slots_size.y)
		var tex = ImageTexture.create_from_image(img)
		$TextureRect.texture = tex

func _process(_delta):
	if player_reference == null:
		player_reference = get_parent().player_reference
	if !activated and player_reference:
		var attributes : CharacterMagicalAttributes = player_reference.get_node("CharacterMagicalAttributes")
		if light_attribute_required <= attributes.light and dark_attribute_required <= attributes.dark and nature_attribute_required <= attributes.nature and arcane_attribute_required <= attributes.arcane:
			activated = true
	if activated:
		$ColorRect.visible = false
