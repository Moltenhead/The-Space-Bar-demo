extends PlayerResource
class_name CatchableResource

export(Vector3) var falling_direction =  Vector3(0, -1, 0)
export(float) var rotation_magnitude = 15
export(float) var falling_speed = 70

var velocity = Vector3(0, 0, 0)
var delta_velocity = Vector3(0, 0, 0)

func _physics_process(delta):
	update_falling(delta, Vector3(0, 0, 0))

func update_falling(delta, _direction):
	var new_position = falling_speed * falling_direction
	var delta_position = new_position * delta
	
	rotate_y(rotation_magnitude * delta)
	delta_velocity = move_and_slide(delta_position, Vector3(0, 1, 0))

func add_to_player():
	CtrlPlayerResources.add_resource(resource_name)
	disable()

func disable():
	queue_free()

func enable():
	pass
