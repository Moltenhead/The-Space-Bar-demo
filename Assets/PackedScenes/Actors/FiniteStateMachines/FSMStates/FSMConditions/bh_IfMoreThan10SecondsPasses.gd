extends Node

var _timer = 0

func execute(transition, delta):
	_timer += delta
	return _timer >= 10
