extends Node
class_name BaseFSM
# Need to append FSMState nodes
# 	to preload the needed states for the NPC behaviour
# @initial_state needs to be set in order to set an initial behaviour
# 	is set with a node path from one of it's FSMState nodes

export(NodePath) var initial_state

var parent_character
var _parent_controller
var _actual_state

func _on_ready():
	parent_character = get_parent()
	_set_initial_state()

func _ready():
	_on_ready()

func _process(delta):
	_actual_state.execute(parent_character, delta)

func change_state_to(state):
	if GameState.debug:
		print("%s changing state to %s" % [parent_character, state.name])
		for transition in state._StateTransitions.get_children():
			print("transition: %s" % transition.name )
	set_process(false)
	_actual_state.end(parent_character)
	_actual_state = state
	_actual_state.start(parent_character)
	set_process(true)

func get_state(string: String):
	return get_node(string)

#SET/GET#
func _set_initial_state():
	_actual_state = get_node(initial_state)
	_actual_state.start(parent_character)
