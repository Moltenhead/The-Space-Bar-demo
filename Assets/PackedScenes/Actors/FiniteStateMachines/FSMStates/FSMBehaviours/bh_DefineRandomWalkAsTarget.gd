extends Node

func execute(character):
	character.movement_target = CtrlPopulator.get_random_walking_position()
