extends WorldEnvironment

enum PLAYER_STATE {
	inactive,
	waiting,
	mixing,
	shaking,
	reloading,
	catching,
	space_vision
}
export(PLAYER_STATE) var initial_player_state = PLAYER_STATE.waiting

func _ready():
	var initial_state_name = PLAYER_STATE.keys()[initial_player_state]
	CtrlPlayerController.set_state(initial_state_name)
	CtrlPopulator.world = self
	CtrlPopulator.spawn_position = $Spawn.get_global_transform().origin
	CtrlPopulator.walking_area = $PlayerCamera/WalkingArea
