extends Node

export(String) var state_name
export(int) var state_layer = 0

var _StateTransitions
var _IStart
var _IExecute
var _IEnd

var _state_transitions = []

var _startup_timer 	= 0
var _stay_timer 	= 0
var _recover_timer 	= 0

func _ready():
	_StateTransitions 	= $StateTransitions
	_IStart 			= $IStart
	_IExecute 			= $IExecute
	_IEnd 				= $IEnd
	
	assign_state_transitions()

func execute(target, delta):
	for state_transition in _state_transitions:
		if state_transition.should_transition(self):
			get_parent().set_state(state_transition.target_state.state_name)
	
	return _IExecute.execute(self, target, delta)

func assign_state_transitions():
	for child in _StateTransitions.get_children():
		if child is StateTransition:
			_state_transitions.append(child)

func start(target):
	return _IStart.execute(self, target)
func end(target):
	reset_timers()
	return _IEnd.execute(self, target)

func reset_timers():
	_startup_timer 	= 0
	_stay_timer		= 0
	_recover_timer 	= 0
