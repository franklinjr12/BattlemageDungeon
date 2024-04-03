extends Node2D

@export var active = false

func _ready():
	var children = get_children()
	for c in children:
		if not(c is TextureRect):
			var line = Line2D.new()
			line.width = 2
			add_child(line)
#			line.add_point(global_position)
#			line.add_point(c.global_position)
			line.add_point(position - $TextureRect.size / 2)
			line.add_point(c.position + c.get_node("TextureRect").size / 2)
			line.default_color = Color(0.5,0.5,0.5,1) #gray
			if c.active:
				line.default_color = Color(1,1,1,1) #white
