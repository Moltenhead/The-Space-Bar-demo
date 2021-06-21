extends TextureRect

var progress = 0
var max_progress = 6

func _ready():
	pass

func add_progress():
	get_child(progress).visible = true
	progress += 1

func reset():
	for child in get_children():
		child.visible = false
	progress = 0

func disable():
	visible = false
	reset()

func enable():
	visible = true
