extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0
const drop_experience = 70
const ATTACK_RANGE = 40

enum NpcState {IDLE, CHASING, ATTACKING}

var current_state = NpcState.IDLE
var player_reference = null
var direction_chasing = Vector2.ZERO
var attack_cooldown = 0.5

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var attack = preload("res://scenes/melee_attack.tscn")

var can_attack = false
var attack_on_cooldown = false

func _ready():
	$AttackCooldown.wait_time = attack_cooldown

func _process(delta):
	if $HealthBar.value <= 0:
		died()
	if current_state == NpcState.CHASING:
		handle_chasing()
	elif current_state == NpcState.ATTACKING:
		handle_attacking()


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

func _on_timer_timeout():
	print("starting to attack")
	can_attack = true

func _on_attack_cooldown_timeout():
	attack_on_cooldown = false

func handle_chasing():
	var running_scene = get_parent()
	if running_scene.name == "world":
		if player_reference == null:
			player_reference = running_scene.get_node("Player")
		direction_chasing = player_reference.position - position
		velocity.x = direction_chasing.normalized().x * SPEED
		if (player_reference.position - position).length() < ATTACK_RANGE:
			current_state = NpcState.ATTACKING
			print("changing state to attack")

func handle_attacking():
	if (player_reference.position - position).length() > ATTACK_RANGE:
		current_state = NpcState.CHASING
		print("changing state to chasing")
	else:
		if can_attack and !attack_on_cooldown:
			print("attacking")
			attack_on_cooldown = true
			$AttackCooldown.start()
			var running_scene = get_parent()
			var new_attack = attack.instantiate()
			var npc_shape_offset = $CollisionShape2D.shape.radius
			var offset_x = 0
			var attack_shape_offset = new_attack.get_node("CollisionShape2D").shape.radius
			if player_reference.position.x > position.x:
				offset_x += attack_shape_offset * 1.5 + attack_shape_offset
			else:
				offset_x += -attack_shape_offset * 1.5 - attack_shape_offset
			var v = position
			v.x += offset_x
			new_attack.position = v
			running_scene.add_child(new_attack)
