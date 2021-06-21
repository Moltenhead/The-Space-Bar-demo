extends Node

var possible_states: Array
var active_states = {}
var accessible_states = {}

export(NodePath) var initial_state

func _ready():
	possible_states = get_children()
	for state in possible_states:
		if not accessible_states.has([int(state.state_layer)]):
			accessible_states[int(state.state_layer)] = {}
		
		accessible_states[int(state.state_layer)][state.state_name] = state
	
	_set_initial_state()

func _set_initial_state():
	var state = get_node(initial_state)
	active_states[state.state_layer] = state
	state.start(CtrlPlayerController)

func _process(delta):
	execute(CtrlPlayerController, delta)

func is_active(layer: int, state_name: String):
	if not active_states.has(int(layer)):
		return false
	
	return active_states[int(layer)].state_name == state_name

func has_active(state_name: String):
	for layer in active_states.keys():
		if active_states[int(layer)].state_name == state_name:
			return true
	
	return false

func set_state(state_name: String):
	for state in possible_states:
		if state.state_name == state_name:
			set_process(false)
			if active_states.has(state.state_layer):
				if active_states[state.state_layer].script:
					active_states[state.state_layer].end(CtrlPlayerController)
			active_states[state.state_layer] = state
			active_states[state.state_layer].start(CtrlPlayerController)
			set_process(true)
			CtrlPlayerController.emit_signal("on_state_change", state_name)
			return true
	
	return false

func execute(target, delta):
	for layer in active_states.keys():
		active_states[int(layer)].execute(target, delta)
