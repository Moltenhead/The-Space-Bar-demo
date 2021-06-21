extends Node
class_name BaseFSMStateTransition
# Need to set the interface with a condition behaviour
# Need to set @target_state_path with a FSMState from the wrapping FSM
#	is consumed by the parent FSMState that uses it as a parameter
#	for FSM.change_state_to(@target_state)

export(NodePath) 	var target_state_path
export(String) 		var debug_message
export(bool) 		var active = true

var target_state

var _IStateTransitionCondition

func _on_ready():
	_IStateTransitionCondition = $IStateTransitionCondition
	_assign_target_state()

func _ready():
#	_on_ready()
	_IStateTransitionCondition = $IStateTransitionCondition
	_assign_target_state()

func _assign_target_state():
	target_state = get_node(target_state_path)

func should_transition(character, delta):
	if not active:
		return false
	
	return _IStateTransitionCondition.execute(character, delta)
