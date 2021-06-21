extends "res://Assets/PackedScenes/Actors/BaseActor/BaseActor.gd"

export(int) var money_asked = 5

func _ready():
	prefer = "money"

func take_player_money():
	CtrlPlayerResources.sub_resource("money", CtrlPopulator.get_upkeep())
	CtrlPlayerController.PlayerCamera.play_sound("LoseMoney")
