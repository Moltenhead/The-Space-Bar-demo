extends Node

func execute(character):
	CtrlPopulator.awaiting_consumers.append(character)
	character.movement_target = Vector3(CtrlPopulator.meeting_queue.get_global_transform().origin)
