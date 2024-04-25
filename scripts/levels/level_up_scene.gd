extends Node

signal level_complete

var player_reference : Player = null

const prepared_spells_position = Vector2(488, 480)
var prepared_spells_node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	player_reference = get_node("Player")
	# disable player gravity and camera
	player_reference.visible = false
	player_reference.process_mode = Node.PROCESS_MODE_DISABLED
	player_reference.get_node("Camera2D").enabled = false
	prepared_spells_node = player_reference.get_node("Camera2D/PlayerCombatUI/PlayerPreparedSpellsUI")
	prepared_spells_node.visible = false
	prepared_spells_node.get_parent().remove_child(prepared_spells_node)
	add_child(prepared_spells_node)
	prepared_spells_node.position = prepared_spells_position
	player_reference.recover_health()
	set_attributes_labels()
	$SkillTree.player_reference = player_reference
	if player_reference.level_up_points > 0:
		$LevelUpArrow.visible = true

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
	# add back the prepared spells to player combat ui
	remove_child(prepared_spells_node)
	var player_combat_ui_node = player_reference.get_node("Camera2D/PlayerCombatUI")
	player_combat_ui_node.add_child(prepared_spells_node)
	prepared_spells_node.visible = true
	prepared_spells_node.position = player_combat_ui_node.player_prepared_spells_position
	player_reference.get_node("Camera2D/PlayerCombatUI/LevelUpArrow").visible = false
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

func assing_spell_to_current_slot(spell : PackedScene):
	var slot = $PlayerPreparedSpellsUI.current_spell
	$PlayerPreparedSpellsUI.assign_new_spell_to_slot(spell.instantiate(), slot)
	if slot == 1:
		player_reference.spell_1 = spell
	elif slot == 2:
		player_reference.spell_2 = spell
	elif slot == 3:
		player_reference.spell_3 = spell
	elif slot == 4:
		player_reference.spell_4 = spell
	# this could cause problem if spell position isnt valid
	player_reference.selected_spell = spell

func _on_light_orb_button_pressed():
	var spell = get_node("SkillTree/LightOrb").spell
	assing_spell_to_current_slot(spell)

func _on_fireball_button_pressed():
	var spell = get_node("SkillTree/Fireball").spell
	assing_spell_to_current_slot(spell)


func _on_arrow_button_pressed():
	var spell = get_node("SkillTree/Arrow").spell
	assing_spell_to_current_slot(spell)

func _on_bolt_button_pressed():
	var spell = get_node("SkillTree/Bolt").spell
	assing_spell_to_current_slot(spell)


func _on_light_mirror_button_pressed():
	var spell = get_node("SkillTree/LightMirror").spell
	assing_spell_to_current_slot(spell)


func _on_magic_missiles_button_pressed():
	var spell = get_node("SkillTree/MagicMissiles").spell
	assing_spell_to_current_slot(spell)


func _on_earth_spike_button_pressed():
	var spell = get_node("SkillTree/EarthSpike").spell
	assing_spell_to_current_slot(spell)


func _on_corruption_cloud_button_pressed():
	var spell = get_node("SkillTree/CorruptionCloud").spell
	assing_spell_to_current_slot(spell)


func _on_light_chain_button_pressed():
	var spell = get_node("SkillTree/LightChain").spell
	assing_spell_to_current_slot(spell)


func _on_creeping_hands_button_pressed():
	var spell = get_node("SkillTree/CreepingHands").spell
	assing_spell_to_current_slot(spell)


func _on_shock_wave_button_pressed():
	var spell = get_node("SkillTree/ShockWave").spell
	assing_spell_to_current_slot(spell)
