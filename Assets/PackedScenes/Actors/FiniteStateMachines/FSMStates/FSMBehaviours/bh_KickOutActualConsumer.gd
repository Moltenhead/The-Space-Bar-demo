extends Node

func execute(character):
	var actual_consumer = CtrlPopulator.actual_consumer
	if actual_consumer != null:
		actual_consumer.set_state("GoToQueue")
	CtrlPopulator.actual_consumer = character
