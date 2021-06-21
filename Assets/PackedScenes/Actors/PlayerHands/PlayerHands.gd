extends Spatial

var _AnimationPlayer

func _ready():
	_AnimationPlayer = $AnimationPlayer

func idle():
	_AnimationPlayer.play("Idle")

func catch(side: String):
	_AnimationPlayer.play("Catch%s" % side.capitalize())

func take_glass():
	_AnimationPlayer.play("TakeGlass")

func stow_glass():
	_AnimationPlayer.play_backwards("TakeGlass")
