extends Node
class_name BaseFSMState
# A state for a Finite State Machine
# Need added FSMStateTransition nodes into StateTransition
#	will handle state transitions
# Need a behaviour set as a script for its interface IExecute
# 	the behaviour will be executed every pass of process

var _StateTransitions
var _IStart
var _IExecute
var _IEnd

var _state_transitions = []
var parent_fsm

var state_name

func _on_ready():
	_StateTransitions 	= $StateTransitions
	_IStart 			= $IStart
	_IExecute 			= $IExecute
	_IEnd 				= $IEnd
	set_parent_fsm()
	assign_state_transitions()

func _ready():
	_on_ready()

func assign_state_transitions():
	for child in _StateTransitions.get_children():
		if child is BaseFSMStateTransition:
			_state_transitions.append(child)

func set_parent_fsm():
	parent_fsm = get_parent()

func start(character):
	_IStart.execute(character)

func execute(character, delta):
	for state_transition in _state_transitions:
		if state_transition.should_transition(parent_fsm.parent_character, delta):
			if GameState.debug and state_transition.debug_message:
				print("%s : %s" % [state_transition.name, state_transition.debug_message])
			return parent_fsm.change_state_to(state_transition.target_state)
	
	_IExecute.execute(character, delta)

func end(character):
	_IEnd.execute(character)

