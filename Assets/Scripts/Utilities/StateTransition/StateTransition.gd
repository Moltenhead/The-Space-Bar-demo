extends Node
class_name StateTransition

export(NodePath) var target_state_path

var target_state

var _IStateTransitionCondition

func _on_ready():
	_IStateTransitionCondition = $IStateTransitionCondition
	_assign_target_state()

func _ready():
	_on_ready()

func _assign_target_state():
	target_state = get_node(target_state_path)

func should_transition(state):
	return _IStateTransitionCondition.execute(CtrlPlayerController, state)
