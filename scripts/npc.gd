extends CharacterBody2D

class_name NPC

signal enemy_died

const JUMP_VELOCITY = -400.0
enum NpcState {IDLE, CHASING, ATTACKING}

@export var has_spells : bool = false

@onready var SPEED = $CharacterAttributes.speed
@onready var drop_experience = $CharacterAttributes.drop_experience

var current_state = NpcState.IDLE
var attack_range = 40
var player_reference = null
var direction_chasing = Vector2.ZERO
var attack_cooldown = 0.5
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var attack = preload("res://scenes/melee_attack.tscn")
@onready var damage_number = preload("res://scenes/damage_number.tscn")
@onready var experience_orb = preload("res://scenes/experience_orb.tscn")

var can_attack = false
var attack_on_cooldown = false

func _ready():
	$AttackCooldown.wait_time = attack_cooldown
	$HealthBar.max_value = $CharacterAttributes.health
	$HealthBar.value = $HealthBar.max_value
	attack_range = get_x_size()
	$Sprite2D.material.set_shader_parameter("flash_modifier", 0)

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
#	var player = get_parent().get_node("Player")
#	player.gain_experience(drop_experience)
	var experience_orb_inst = experience_orb.instantiate()
	experience_orb_inst.position = position
	experience_orb_inst.set_dropped_experience(drop_experience)
	get_parent().call_deferred("add_child", experience_orb_inst)
	

func suffer_damage(damage):
	$HealthBar.value -= damage
	$Sprite2D.material.set_shader_parameter("flash_modifier", 0.6)
	$SpriteFlashTimer.start()
	var new_damage_number = damage_number.instantiate()
	new_damage_number.position = position
	new_damage_number.text = var_to_str(damage)
	get_parent().add_child(new_damage_number)
	if $HealthBar.value <= 0:
		died()


func _on_player_detection_area_body_entered(body):
	# since it should detect only the player as it has its on layer no need to cast ?
	if body is Player:
		change_state(NpcState.CHASING)
#		print("changing state to chasing on body entered")

func _on_player_detection_area_body_exited(body):
	if body is Player:
		change_state(NpcState.IDLE)
#		print("changing state to idle on body exited")

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
		if is_player_in_attack_range():
			velocity.x -= direction_chasing.normalized().x * SPEED
			change_state(NpcState.ATTACKING)
#			print("changing state to attacking")

func is_player_in_attack_range():
	if has_spells:
		var l = (player_reference.position - position).length()
		return l < get_x_size() * 7
	else:
		return (player_reference.position - position).length() <= attack_range

func handle_attacking(_delta):
	if not is_player_in_attack_range():
		change_state(NpcState.CHASING)
#		print("changing state to chasing")
	else:
		if can_attack and !attack_on_cooldown:
			attack_on_cooldown = true
			if has_spells:
				attack_with_spells()
			else:
				attack_melee()

func attack_with_spells() -> void:
	var dir : Vector2 = player_reference.position - position
	dir = dir.normalized()
	var offset_position : Vector2 = position
	var character_body_offset = get_x_size()
	if dir.x > 0:
		offset_position.x += get_x_size()
	else:
		offset_position.x -= get_x_size()
	offset_position.y -= 10
	var casted_cd : float = $Spells.cast(offset_position, dir)
	$AttackCooldown.wait_time = casted_cd
	$AttackCooldown.start()

func attack_melee() -> void:
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
			return shape.height * 1.3
		else:
			return shape.radius * 2.1
	return 1

func change_state(state : NpcState):
	current_state = state


func _on_sprite_flash_timer_timeout():
	$Sprite2D.material.set_shader_parameter("flash_modifier", 0)

