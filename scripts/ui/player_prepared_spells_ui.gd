extends Node2D

const slots_size = Vector2(40,40)
var current_spell = 1

func _ready():
	var img = Image.load_from_file("res://assets/attacks_sprites/basic_spell_20x20.png")
	img.resize(slots_size.x, slots_size.y)
	var tex = ImageTexture.create_from_image(img)
	$HBoxContainer/Slot1.texture = tex
	$HBoxContainer/Slot1/ColorRect.visible = false
	img = Image.load_from_file("res://assets/attacks_sprites/fireball.png")
	img.resize(slots_size.x, slots_size.y)
	tex = ImageTexture.create_from_image(img)
	$HBoxContainer/Slot2.texture = tex
	img = Image.load_from_file("res://assets/attacks_sprites/arrow_spell.png")
	img.resize(slots_size.x, slots_size.y)
	tex = ImageTexture.create_from_image(img)
	$HBoxContainer/Slot3.texture = tex
	img = Image.load_from_file("res://assets/attacks_sprites/bolt_spell.png")
	img.resize(slots_size.x, slots_size.y)
	tex = ImageTexture.create_from_image(img)
	$HBoxContainer/Slot4.texture = tex
	pass

func _process(_delta):
	check_inputs()
	
func select_spell(spell_num : int):
	var current = get_node("HBoxContainer/Slot" + var_to_str(current_spell))
	current.get_node("ColorRect").visible = true
	current_spell = spell_num
	current = get_node("HBoxContainer/Slot" + var_to_str(current_spell))
	current.get_node("ColorRect").visible = false

func check_inputs():
	if Input.is_action_just_pressed("select_spell_1"):
		select_spell(1)
	if Input.is_action_just_pressed("select_spell_2"):
		select_spell(2)
	if Input.is_action_just_pressed("select_spell_3"):
		select_spell(3)
	if Input.is_action_just_pressed("select_spell_4"):
		select_spell(4)
