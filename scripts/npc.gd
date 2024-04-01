extends CharacterBody2D

signal enemy_died

@onready var SPEED = $CharacterAttributes.speed
const JUMP_VELOCITY = -400.0
@onready var drop_experience = $CharacterAttributes.drop_experience

enum NpcState {IDLE, CHASING, ATTACKING}

var current_state = NpcState.IDLE
var attack_range = 40
var player_reference = null
var direction_chasing = Vector2.ZERO
var attack_cooldown = 0.5
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var attack = preload("res://scenes/melee_attack.tscn")

var can_attack = false
var attack_on_cooldown = false

func _ready():
	$AttackCooldown.wait_time = attack_cooldown
	$HealthBar.max_value = $CharacterAttributes.health
	$HealthBar.value = $HealthBar.max_value
	attack_range = get_x_size()

func _process(delta):
	if current_state == NpcState.IDLE:
		pass
	elif current_state == NpcState.CHASING:
		handle_chasing(delta)
	elif current_state == NpcState.ATTACKING:
		handle_attacking(delta)


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

func died():
	give_exp()
	enemy_died.emit()
	queue_free()

func give_exp():
	var player = get_parent().get_node("Player")
	player.gain_experience(drop_experience)

func suffer_damage(damage):
	$HealthBar.value -= damage
	if $HealthBar.value <= 0:
		died()


func _on_player_detection_area_body_entered(body):
	# since it should detect only the player as it has its on layer no need to cast ?
	if body is CharacterBody2D:
		change_state(NpcState.CHASING)
		print("changing state to chasing on body entered")

func _on_timer_timeout():
	can_attack = true

func _on_attack_cooldown_timeout():
	attack_on_cooldown = false

func handle_chasing(_delta):
	var running_scene = get_parent()
	if running_scene.name == "world":
		if player_reference == null:
			player_reference = running_scene.get_node("Player")
		direction_chasing = player_reference.position - position
		if player_reference.position.x < position.x:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
		velocity.x = direction_chasing.normalized().x * SPEED
		print("dist ", (player_reference.position - position).length(), " range ", attack_range)
		if (player_reference.position - position).length() <= attack_range:
			velocity.x -= direction_chasing.normalized().x * SPEED
			change_state(NpcState.ATTACKING)
			print("changing state to attacking")

func handle_attacking(_delta):
	if (player_reference.position - position).length() > attack_range:
		change_state(NpcState.CHASING)
		print("changing state to chasing")
	else:
		if can_attack and !attack_on_cooldown:
			attack_on_cooldown = true
			$AttackCooldown.start()
			var running_scene = get_parent()
			var new_attack = attack.instantiate()
			new_attack.damage = $CharacterAttributes.damage
			var shape = $CollisionShape2D.shape
			var npc_shape_offset = 0
			if shape is CapsuleShape2D:
				npc_shape_offset = shape.radius
			elif shape is RectangleShape2D:
				npc_shape_offset = shape.size.x
			var offset_x = 0
			var attack_shape_offset = new_attack.get_node("CollisionShape2D").shape.radius
			if player_reference.position.x > position.x:
				offset_x += attack_shape_offset * 1.5 + 1.5 * npc_shape_offset
			else:
				offset_x += -attack_shape_offset * 1.5 - 1.5 * npc_shape_offset
				new_attack.get_node("Sprite2D").flip_h = true
			var v = position
			v.x += offset_x
			new_attack.position = v
			running_scene.add_child(new_attack)

func get_x_size() -> float:
	var shape = $CollisionShape2D.shape
	if shape is RectangleShape2D:
		return shape.size.x * 3
	elif shape is CircleShape2D:
		return shape.radius * 2
	elif shape is CapsuleShape2D:
		# in some the capsule is rotated, so the actual x size is on height
		if $CollisionShape2D.rotation != 0:
			return shape.height
		else:
			return shape.radius
	return 1

func change_state(state : NpcState):
	current_state = state
