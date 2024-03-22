extends CharacterBody2D

@export var player_speed = 100
@export var PLAYER_JUMP_VALUE = -1000
@export var PLAYER_JUMP_TIMEOUT_SECONDS = 0.3


var can_jump = true

var WORLD_GRAVITY : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_acceleration = Vector2.ZERO

var jumping = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$JumpTimer.one_shot = true
	$JumpTimer.wait_time = PLAYER_JUMP_TIMEOUT_SECONDS

func _process(delta):
	pass

func _physics_process(delta):
	# Add the gravity.
	velocity.y += WORLD_GRAVITY * delta
	if Input.is_action_just_pressed("player_jump"):
		if can_jump:
			print("jumping")
			can_jump = false
			jumping = true
#			velocity.y += PLAYER_JUMP_VALUE
			$JumpTimer.start()	
	if Input.is_action_just_released("player_jump"):
		jumping = false
		print("stopping jump")
	if Input.is_action_pressed("player_move_right"):
		position.x += player_speed*delta
	if Input.is_action_just_released("player_move_right"):
		position.x -= player_speed*delta
	if Input.is_action_pressed("player_move_left"):
		position.x -= player_speed*delta
	if Input.is_action_just_released("player_move_left"):
		position.x += player_speed*delta
	if jumping:
		velocity.y += PLAYER_JUMP_VALUE*delta
	move_and_slide()
	
func _on_jump_timer_timeout():
	print("jump timeout")
	can_jump = true
	jumping = false

