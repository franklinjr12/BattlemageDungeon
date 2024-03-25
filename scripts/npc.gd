extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0
const drop_experience = 70

enum NpcState {IDLE, CHASING}

var current_state = NpcState.IDLE
var player_reference = null
var direction_chasing = Vector2.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(delta):
	if $HealthBar.value <= 0:
		died()
	if current_state == NpcState.CHASING:
		var running_scene = get_parent()
		if running_scene.name == "world":
			if player_reference == null:
				player_reference = running_scene.get_node("Player")
			direction_chasing = player_reference.position - position
			velocity.x = direction_chasing.normalized().x * SPEED


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


func _on_player_detection_area_body_entered(body):
	# since it should detect only the player as it has its on layer no need to cast ?
	if body is CharacterBody2D:
		current_state = NpcState.CHASING
		print("chasing player now")

