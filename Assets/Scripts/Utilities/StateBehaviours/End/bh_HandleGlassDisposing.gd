extends Node

func execute(_state, target):
	var camera = target.PlayerCamera
	camera.disable_ingredient_ui()
	camera._PlayerHands.stow_glass()
