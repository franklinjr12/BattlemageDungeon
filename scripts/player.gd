extends CharacterBody2D

@export var player_speed = 100
@export var PLAYER_JUMP_VALUE = -1000
@export var PLAYER_JUMP_TIMEOUT_SECONDS = 0.3

const INITIAL_HP = 100

var can_jump = true
var WORLD_GRAVITY : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_acceleration = Vector2.ZERO
var jumping = false
var current_hp = INITIAL_HP
const LEVEL_UP_THRESHOLD = 100
var current_exp = 0
var current_level = 0
var next_level = 1
var level_up_points = 0

@onready var basic_projectile = preload("res://scenes/basic_projectile.tscn")
@onready var attack = preload("res://scenes/melee_attack.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	$JumpTimer.one_shot = true
	$JumpTimer.wait_time = PLAYER_JUMP_TIMEOUT_SECONDS

func _process(delta):
	if Input.is_action_just_pressed("cast"):
		cast_spell()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += WORLD_GRAVITY * delta
	if Input.is_action_just_pressed("player_jump"):
		if can_jump:
			can_jump = false
			jumping = true
			$JumpTimer.start()	
	if Input.is_action_just_released("player_jump"):
		jumping = false
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
	can_jump = true
	jumping = false

func cast_spell():
	# if we are in the a valid game scene
	var running_scene = get_parent()
	if running_scene.name == "world":
		var new_projectile = basic_projectile.instantiate()
		new_projectile.who_casted = self
		var mpos = get_global_mouse_position()
		var offset_position = position
		var character_body_offset = $CollisionShape2D.shape.get_rect().size.x / 2
		var projectile_body_offset =  new_projectile.get_node("CollisionShape2D").shape.get_rect().size.x
		var offset_x = character_body_offset + projectile_body_offset
		if mpos.x > position.x:
			offset_position.x += offset_x
		else:
			offset_position.x -= offset_x
		var dir = mpos - offset_position
		dir = dir.normalized()
		new_projectile.velocity = dir * new_projectile.VELOCITY_MAG
		new_projectile.position = offset_position
		running_scene.add_child(new_projectile)

func gain_experience(experience):	
	current_exp += experience
	if current_exp >= next_level * LEVEL_UP_THRESHOLD:
		next_level += 1
		current_level += 1
		level_up_points += 1
	print("current_exp ", current_exp, " current_level ", current_level, " level_up_points ", level_up_points)
#	var format_string = "%s was reluctant to learn %s, but now he enjoys it."
#	var actual_string = format_string % ["Estragon", "GDScript"]
#	print(actual_string)

func suffer_damage(damage):
	current_hp -= damage
