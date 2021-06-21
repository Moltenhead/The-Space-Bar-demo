extends Node

func execute(controller, _state):
	var progress_bar = controller.PlayerCamera._GameUi._ShakeProgressBar
	return progress_bar.progress == progress_bar.max_progress
