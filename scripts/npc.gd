extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var drop_experience = 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(delta):
	if $HealthBar.value <= 0:
		died()
		
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

func died():
	give_exp()
	queue_free()

func give_exp():
	var player = get_parent().get_node("Player")
	player.gain_experience(drop_experience)

func suffer_damage(damage):
	$HealthBar.value -= damage
