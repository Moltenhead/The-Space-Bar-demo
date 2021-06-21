extends Node

func execute(_state, _target):
	CtrlPlayerController.PlayerCamera._GameUi._ShakeProgressBar.disable()
	CtrlPlayerController.give_cocktail()
