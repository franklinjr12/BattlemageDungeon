extends Area2D


var damage_number = preload("res://scenes/damage_number.tscn")

@onready var speed = $SpellAttributes.speed
@onready var damage = $SpellAttributes.damage
@onready var cooldown = $SpellAttributes.cooldown
var direction = Vector2.ZERO
var who_casted = null

# Called when the node enters the scene tree for the first time.
func _ready():
	print("spell ready cooldown ", cooldown)

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body is StaticBody2D:
		print("collided with floor or wall")
	elif body is CharacterBody2D:
		body.suffer_damage(damage)
		var new_damage_number = damage_number.instantiate()
		new_damage_number.position = position
		new_damage_number.text = var_to_str(damage)
		get_parent().add_child(new_damage_number)
	queue_free()

func set_direction(dir):
	direction = dir
	# rotate the sprite
	$Sprite2D.rotate(atan2(dir.y,dir.x))

func get_size() -> float:
	var shape = $CollisionShape2D.shape
	if shape is RectangleShape2D:
		return shape.size.x
	elif shape is CircleShape2D:
		return shape.radius * 2
	return 1
