extends Spatial

var _Area
var _PlayerArea
var _PlayerLeftCatch
var _PlayerRightCatch

func _ready():
	_Area = $Area
	_PlayerArea = $PlayerArea
	_PlayerLeftCatch = $PlayerArea/LeftCatch
	_PlayerRightCatch = $PlayerArea/RightCatch
	_set_player_catches_inactive()

func _set_player_catches_inactive():
	for catch in _PlayerArea.get_children():
		catch.disabled = true

func set_catch_activation(side: String, boolean: bool):
	match side:
		'left':
			_PlayerLeftCatch.disabled = !boolean
		'right':
			_PlayerRightCatch.disabled = !boolean


func _on_Area_body_exited(body):
	if body is CatchableResource:
		body.disable()

func _on_PlayerArea_body_entered(body):
	if body is CatchableResource:
		body.add_to_player()
