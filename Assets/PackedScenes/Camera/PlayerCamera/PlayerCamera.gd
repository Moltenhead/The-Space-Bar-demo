extends Spatial

var _GameUi
var _IngredientUi
var _PlayerHands
var _InteractionArea
var _InteractionShape
var _AnimationPlayer
var _Cocktail

var _MeetingPlace
var _MeetingQueue

var _WalkingArea

var _Sounds

func _ready():
	_GameUi				= $Arm/Camera/GameUi
	_IngredientUi 		= $IngredientUi
	_PlayerHands 		= $PlayerHands
	_Cocktail			= $PlayerHands/RightHand/Cocktail
	
	_InteractionArea 	= $InteractionArea
	_InteractionShape 	= $InteractionArea/Area/CollisionShape
	
	_AnimationPlayer 	= $AnimationPlayer
	
	_MeetingPlace = $MeetingArea/MeetingPlace
	_MeetingQueue = $MeetingArea/MeetingQueue
	
	_WalkingArea = $WalkingArea
	
	_Sounds = $Sounds
	
	CtrlPopulator.meeting_place = _MeetingPlace
	CtrlPopulator.meeting_queue = _MeetingQueue
	
	CtrlPlayerController.PlayerCamera = self
	
	CtrlPlayerController.connect("on_state_change", self, "_handle_animation")

func give_spawnable_item_location():
	var interaction_area_origin = Vector3(0, 0, 0)#Vector3(_InteractionShape.get_global_transform().origin)
	var interaction_extents = Vector3(_InteractionShape.shape.extents)
	
	interaction_area_origin.x += rand_range(-interaction_extents.x, interaction_extents.x)
	interaction_area_origin.y += interaction_extents.y
	#interaction_area_origin.z += rand_range(-interaction_extents.z, interaction_extents.z)
	return interaction_area_origin

func set_catch_activation(side: String, boolean: bool):
	_InteractionArea.set_catch_activation(side, boolean)

func _handle_animation(state_name):
	match state_name:
		'waiting':
			_AnimationPlayer.play("Waiting")
			_PlayerHands._AnimationPlayer.queue("Idle")
		'catching':
			_AnimationPlayer.stop()
			_PlayerHands.catch(CtrlPlayerController.catch_direction)
		'mixing':
			_AnimationPlayer.stop()
			_PlayerHands.take_glass()
		_:
			_AnimationPlayer.stop()

func enable_ingredient_ui():
	_IngredientUi.visible = true
func disable_ingredient_ui():
	_IngredientUi.visible = false
	_IngredientUi.deselect()

func get_selected_ingredient():
	return _IngredientUi.selected

func select_ingredient(i: int):
	return _IngredientUi.select(i)

func deselect_ingredient():
	_IngredientUi.deselect()

func set_ingredient(byte: int, boolean: bool):
	_IngredientUi.set_selected(byte, boolean)

func toggle_ingredient(byte: int):
	_IngredientUi.toggle_selected(byte)

func hide_all():
	_GameUi.visible = false
	_PlayerHands.visible = false

func show_all():
	_GameUi.visible = true
	_PlayerHands.visible = true

func play_sound(sound_name: String):
	var stream = _Sounds.get_node(sound_name)
	if stream == null:
		return
	
	stream.play()
