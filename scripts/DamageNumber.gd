extends Label

const VELOCITY = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	position.y -= VELOCITY

func _on_timer_timeout():
	queue_free()
