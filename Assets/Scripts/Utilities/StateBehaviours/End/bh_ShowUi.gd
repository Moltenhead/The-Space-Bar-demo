extends Node

func execute(state, target):
	if target.PlayerCamera == null:
		return
	
	target.PlayerCamera.show_all()
