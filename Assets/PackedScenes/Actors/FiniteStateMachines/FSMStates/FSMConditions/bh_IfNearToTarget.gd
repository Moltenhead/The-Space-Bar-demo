extends Node

func execute(character, _delta):
	return character.movement_target != null and character.movement_target.distance_squared_to(character.get_global_transform().origin) < 0.15
