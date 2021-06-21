extends Node

func execute(character, delta):
	var target = character.movement_target
	if target == null:
		return
	
	var character_origin = character.get_global_transform().origin
	target.y = character_origin.y
	var direction = (target - character_origin).normalized()
	var target_vector = direction * 500 * delta
	character.move_and_slide(target_vector, Vector3(0, 1, 0))
