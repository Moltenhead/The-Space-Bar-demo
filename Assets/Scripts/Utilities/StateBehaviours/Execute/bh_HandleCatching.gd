extends Node

func execute(state, _target, delta):
	var startup = CtrlPlayerController.catching_startup
	var stay 	= CtrlPlayerController.catching_stay
	
	if state._stay_timer > stay:
		if state._recover_timer == 0:
			CtrlPlayerController.set_catch_activation(false)
			CtrlPlayerController.catch_direction = null
		state._recover_timer += delta
		return
	
	if state._startup_timer > startup:
		if state._stay_timer == 0:
			CtrlPlayerController.set_catch_activation(true)
		state._stay_timer += delta
		return
	
	state._startup_timer += delta
