extends Node

var _timer = 0

func execute(_transition, delta):
	_timer += delta
	if _timer >= 5:
		_timer = 0
		return true
	
	return false
