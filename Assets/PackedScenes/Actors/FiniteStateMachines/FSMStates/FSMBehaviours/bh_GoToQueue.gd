extends Node

func execute(character, delta):
	var queue_origin = Vector3(CtrlPopulator.meeting_queue.get_global_transform().origin)
	var character_origin = character.get_global_transform().origin
	queue_origin.y = character_origin.y
	var direction = (queue_origin - character_origin).normalized()
	var target_vector = direction * 500 * delta
	character.move_and_slide(target_vector, Vector3(0, 1, 0))
