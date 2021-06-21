extends Node

signal on_state_change(state_name)

var _StateManager
var PlayerCamera #set from player actor _ready()

export(float) var catching_startup 	= .05
export(float) var catching_stay 	= .2
export(float) var catching_recover 	= .05

var action_timer = 0

var possible_states = [
	["inactive", null, 0],
	["waiting", null, 0],
	["mixing", null, 0],
	["shaking", null, 0],
	["reloading", null, 0],
	["catching", null, 0],
	["space_vision", null, 1],
]

var catch_direction
var last_ingredient_selected
var last_ingredient_index
var selected_ingredient

var pill_ingredient = preload("res://Assets/PackedScenes/Resources/BaseIngredient/Pill.tscn")
var pill_ingredient_istance

func _ready():
	_StateManager = $StateManager
	pill_ingredient_istance = pill_ingredient.instance()

func _input(event):
	if not event is InputEventKey:
		return
	
	if is_active(0, "inactive") or is_active(0, "catching"):
		return
	 
	if is_active(0, "reloading") and Input.is_action_just_pressed("ui_cancel"):
			#TODO handle cancel, got to waiting
			return
	
	if is_active(0, "shaking"):
		if Input.is_action_just_pressed("ui_cancel"):
			set_state("waiting")
			return
		
		if Input.is_action_just_pressed("ui_accept"):
			_shake()
			return
	
	if is_active(0, "waiting"):
		if Input.is_action_just_pressed("ui_up"):
			return  set_state("mixing")
		
		if Input.is_action_just_pressed("ui_accept"):
			var horizontal_direction = _get_horizontal_input()
			if horizontal_direction == 0:
				#TODO trigger failed to catch
				return
			
			catch_direction = _horizontal_direction_to_string(horizontal_direction)
			return set_state("catching")
		
		if Input.is_action_just_pressed("ui_special"):
			#TODO triggerspace_vision if present pill
			return
	
	if is_active(0, "mixing"):
		if Input.is_action_just_pressed("ui_cancel"):
			return set_state("waiting")
		
		if Input.is_action_just_pressed("ui_special"):
			if CtrlPlayerResources.sub_resource("pill"):
				return _add_pill()
			
			return
		
		if Input.is_action_just_pressed("any_selection"):
			var i = _just_pressed_to_int()
			last_ingredient_index = i
			selected_ingredient = PlayerCamera.select_ingredient(i)
			return
		
		if Input.is_action_just_released("any_selection"):
			var i = _just_released_to_int()
			if i == last_ingredient_index:
				PlayerCamera.deselect_ingredient()
			return
		
		if Input.is_action_just_released("ui_accept"):
			if selected_ingredient:
				_add_ingredient()
				return

func _get_horizontal_input():
	return int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))

func _horizontal_direction_to_string(i: int):
	match i:
		-1:
			return "left"
		0:
			return null
		1:
			return "right"

func _input_to_byte():
	return int(Input.is_action_pressed("ui_left")) + int(Input.is_action_pressed("ui_up")) * 2 + int(Input.is_action_pressed("ui_right")) * 4

func _just_pressed_to_byte():
	return int(Input.is_action_just_pressed("ui_left")) + int(Input.is_action_just_pressed("ui_up")) * 2 + int(Input.is_action_just_pressed("ui_right")) * 4

func _just_pressed_to_int():
	return int(Input.is_action_just_pressed("ui_left")) + int(Input.is_action_just_pressed("ui_up")) * 2 + int(Input.is_action_just_pressed("ui_right")) * 3

func _just_released_to_byte():
	return int(Input.is_action_just_released("ui_left")) + int(Input.is_action_just_released("ui_up")) * 2 + int(Input.is_action_just_released("ui_right")) * 4

func _just_released_to_int():
	return int(Input.is_action_just_released("ui_left")) + int(Input.is_action_just_released("ui_up")) * 2 + int(Input.is_action_just_released("ui_right")) * 3

func is_active(layer: int, state_name: String):
	return _StateManager.is_active(layer, state_name)

func has_active(state_name: String):
	return _StateManager.has_active(state_name)

func set_state(state_name: String):
	return _StateManager.set_state(state_name)

func set_catch_activation(boolean: bool):
	PlayerCamera.set_catch_activation(catch_direction, boolean)

func _add_ingredient():
	PlayerCamera._Cocktail.add_ingredient(selected_ingredient.get_ingredient())

func _add_pill():
	PlayerCamera._Cocktail.add_ingredient(pill_ingredient_istance)

func _shake():
	#TODO handle shaking animation
	PlayerCamera._GameUi._ShakeProgressBar.add_progress()

func give_cocktail():
	if CtrlPopulator.actual_consumer != null:
		CtrlPopulator.actual_consumer.given_cocktail = CtrlPlayerController.PlayerCamera._Cocktail.duplicate()
		if CtrlPlayerController.PlayerCamera._Cocktail.ingredients[0].ingredient_name == "pill" and CtrlPopulator.cop_count > 0:
			game_over("caught")
		else:
			PlayerCamera.play_sound("GiveCocktail")
	CtrlPlayerController.PlayerCamera._Cocktail.reset()

func game_over(type: String):
	match type:
		"caught":
			#TODO go to jail
			pass
		"killed":
			#TODO die
			pass
