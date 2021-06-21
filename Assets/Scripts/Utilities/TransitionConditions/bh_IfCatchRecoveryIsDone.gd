extends Node

func execute(controller, state):
	controller.PlayerCamera.disable_ingredient_ui()
	return state._recover_timer > controller.catching_recover
