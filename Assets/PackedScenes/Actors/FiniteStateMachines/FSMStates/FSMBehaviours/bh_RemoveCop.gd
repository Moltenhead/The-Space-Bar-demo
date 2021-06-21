extends Node

func execute(character):
	CtrlPopulator.awaiting_consumers.erase(character)
	CtrlPopulator.cop_count -= 1
	character.queue_free()
