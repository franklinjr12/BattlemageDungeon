extends Area2D

class_name Spell

var damage_number = preload("res://scenes/damage_number.tscn")
var spell_impact = preload("res://scenes/spells/spell_impact.tscn")

@onready var speed = $SpellAttributes.speed
@onready var damage = $SpellAttributes.damage
@onready var cooldown = $SpellAttributes.cooldown
var direction = Vector2.ZERO
var who_casted = null

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body is StaticBody2D:
		print("spell do animation")
	elif body is CharacterBody2D:
		body.suffer_damage(damage)
		var new_damage_number = damage_number.instantiate()
		new_damage_number.position = position
		new_damage_number.text = var_to_str(damage)
		get_parent().add_child(new_damage_number)
	var animation = spell_impact.instantiate()
	animation.position = position
	get_parent().add_child(animation)
	queue_free()

func set_direction(dir):
	direction = dir
	# rotate the sprite
	rotate(atan2(dir.y,dir.x))

func get_size() -> float:
	var shape = $CollisionShape2D.shape
	if shape is RectangleShape2D:
		return shape.size.x
	elif shape is CircleShape2D:
		return shape.radius * 2
	elif shape is CapsuleShape2D:
		# in some the capsule is rotated, so the actual x size is on height
		if $CollisionShape2D.rotation != 0:
			return shape.height
		else:
			return shape.radius
	return 1
