extends CharacterBody2D

class_name Player

@export var player_speed = 300
@export var PLAYER_JUMP_VALUE = -2000
@export var spell_offset_value : float = 1.5

signal player_died

const PLAYER_JUMP_TIMEOUT_SECONDS = 0.3
const INITIAL_HP = 100
const LEVEL_UP_THRESHOLD = 100
var spell_changed = false
var can_jump = true
var WORLD_GRAVITY : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_acceleration = Vector2.ZERO
var jumping = false
var current_hp = INITIAL_HP
var current_exp = 0
var current_level = 0
var next_level = 1
var level_up_points = 5
var is_spell_on_cooldown = false

#@onready var basic_projectile = preload("res://scenes/basic_projectile.tscn")
@onready var basic_projectile = preload("res://scenes/spells/fireball.tscn")

var spell = preload("res://scenes/spells/spell.tscn")
var spell_1 = null
var fireball = preload("res://scenes/spells/fireball.tscn")
var spell_2 = null
var arrow = preload("res://scenes/spells/arrow.tscn")
var spell_3 = null
var bolt = preload("res://scenes/spells/bolt.tscn")
var spell_4 = null
var selected_spell = null
var current_spell_timer = null

func _ready():
	spell_1 = spell
	spell_2 = fireball
	spell_3 = arrow
	spell_4 = bolt
	selected_spell = spell_1
	$JumpTimer.one_shot = true
	$JumpTimer.wait_time = PLAYER_JUMP_TIMEOUT_SECONDS

func _process(_delta):
	check_inputs()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += WORLD_GRAVITY * delta
	else:
		can_jump = true
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

func check_inputs():
	if Input.is_action_just_pressed("cast"):
		cast_spell()
	if Input.is_action_just_pressed("select_spell_1"):
		selected_spell = spell_1
		spell_changed = true
	if Input.is_action_just_pressed("select_spell_2"):
		selected_spell = spell_2
		spell_changed = true
	if Input.is_action_just_pressed("select_spell_3"):
		selected_spell = spell_3
		spell_changed = true
	if Input.is_action_just_pressed("select_spell_4"):
		selected_spell = spell_4
		spell_changed = true

func _on_jump_timer_timeout():
	jumping = false

func cast_spell():
	# if isnt on cooldown
	if is_spell_on_cooldown:
		return
	# if we are in the a valid game scene
	var running_scene = get_parent()
	if running_scene.name == "world":
		var new_projectile = selected_spell.instantiate()
		new_projectile.who_casted = self
		var mpos = get_global_mouse_position()
		var offset_position = position
		var character_body_offset = $CollisionShape2D.shape.get_rect().size.x / 2
		var projectile_body_offset = new_projectile.get_size() * spell_offset_value
		var offset_x = character_body_offset + projectile_body_offset
		if mpos.x > position.x:
			offset_position.x += offset_x
		else:
			offset_position.x -= offset_x
		var dir = mpos - offset_position
		dir = dir.normalized()
		new_projectile.set_direction(dir)
		new_projectile.position = offset_position
		running_scene.add_child(new_projectile)
		$SpellTimer.wait_time = new_projectile.cooldown
		$SpellTimer.start()
		is_spell_on_cooldown = true

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
	if current_hp <= 0:
		print("player died")
		player_died.emit()

func _on_spell_timer_timeout():
	is_spell_on_cooldown = false
