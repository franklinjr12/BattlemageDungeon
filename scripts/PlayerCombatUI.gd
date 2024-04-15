extends Node2D

var player = null
const MAX_EXPERIENCE = 100
const player_prepared_spells_position = Vector2(281, -57)

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_parent()
	listen_player_leveled_up_signal()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	setCurrentHealth(player.current_hp)
	setCurrentExperience(player.current_exp)

func setCurrentHealth(value):
	$PlayerHealthDisplay.value = value
	$PlayerHealthDisplay/HealthLabel.text = var_to_str(value)

func setCurrentExperience(value):
	var set_value = value
	if value > MAX_EXPERIENCE:
		set_value = value % MAX_EXPERIENCE
	$PlayerExperienceDisplay.value = set_value
	$PlayerExperienceDisplay/ExperienceLabel.text = var_to_str(set_value)

func listen_player_leveled_up_signal() -> void:
	player.leveled_up.connect(on_player_leveled_up)

func on_player_leveled_up() -> void:
	$CurrentLevel.text = var_to_str(player.current_level)
	$LevelUpArrow.visible = true
