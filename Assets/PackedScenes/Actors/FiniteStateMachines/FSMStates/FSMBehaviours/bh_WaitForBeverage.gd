extends Node

var _timer = 0
var _iterations = 0

func execute(character, delta):
	_timer += delta
	if _timer >= 1:
		_timer = 0
		_iterations += 1
		character.contentment -= 1
