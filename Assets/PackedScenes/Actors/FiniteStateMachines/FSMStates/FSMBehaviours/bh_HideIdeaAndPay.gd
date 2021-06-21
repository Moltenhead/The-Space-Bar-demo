extends Node

func execute(character):
	character.hide_idea()
	character.pay()
	CtrlPopulator.request_next_consumer()
