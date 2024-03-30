extends Node2D

var player = null
const MAX_EXPERIENCE = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_parent()

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
