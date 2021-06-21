extends Node

var _timer = 0

func execute(_transition, delta):
	_timer += delta
	return _timer >= 2
