extends Node

signal level_complete

var player_reference : Player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	player_reference = get_node("Player")
	# disable player gravity and camera
	player_reference.visible = false
	player_reference.process_mode = Node.PROCESS_MODE_DISABLED
	player_reference.get_node("Camera2D").enabled = false
	player_reference.recover_health()
	set_attributes_labels()
	$SkillTree.player_reference = player_reference

func _process(_delta):
	set_attributes_labels()

func set_attributes_labels():
	$CharacterAttributesOptions/Values/DarkPointsDisplay/Label.text = var_to_str(player_reference.get_node("CharacterMagicalAttributes").dark)
	$CharacterAttributesOptions/Values/LightPointsDisplay/Label.text = var_to_str(player_reference.get_node("CharacterMagicalAttributes").light)
	$CharacterAttributesOptions/Values/NaturePointsDisplay/Label.text = var_to_str(player_reference.get_node("CharacterMagicalAttributes").nature)
	$CharacterAttributesOptions/Values/ArcanePointsDisplay/Label.text = var_to_str(player_reference.get_node("CharacterMagicalAttributes").arcane)
	$CharacterPointsDisplay/Label.text = "Points left " + var_to_str(player_reference.level_up_points)


func _on_level_up_button_pressed():
	$CharacterAttributesOptions.visible = !$CharacterAttributesOptions.visible
	$CharacterPointsDisplay.visible = !$CharacterPointsDisplay.visible


func _on_next_level_button_pressed():
	print("next level pressed")
	player_reference.visible = true
	player_reference.process_mode = Node.PROCESS_MODE_INHERIT
	player_reference.get_node("Camera2D").enabled = true
	level_complete.emit()


func _on_light_button_pressed():
	if player_reference.level_up_points > 0:
		player_reference.level_up_points -= 1
		player_reference.get_node("CharacterMagicalAttributes").light += 1


func _on_dark_button_pressed():
	if player_reference.level_up_points > 0:
		player_reference.level_up_points -= 1
		player_reference.get_node("CharacterMagicalAttributes").dark += 1

func _on_nature_button_pressed():
	if player_reference.level_up_points > 0:
		player_reference.level_up_points -= 1
		player_reference.get_node("CharacterMagicalAttributes").nature += 1

func _on_arcane_button_pressed():
	if player_reference.level_up_points > 0:
		player_reference.level_up_points -= 1
		player_reference.get_node("CharacterMagicalAttributes").arcane += 1


func _on_prepare_spells_button_pressed():
	$SkillTree.visible = !$SkillTree.visible
	$PlayerPreparedSpellsUI.visible = !$PlayerPreparedSpellsUI.visible
