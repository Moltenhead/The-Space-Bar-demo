extends Node

func execute(character):
	CtrlPopulator.awaiting_consumers.erase(character)
	character.movement_target = Vector3(CtrlPopulator.spawn_position)
