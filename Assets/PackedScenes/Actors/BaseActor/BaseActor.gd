extends KinematicBody

var resource_spread = [
	"money",
	"money",
	"money",
	"money",
	"money",
	"money",
	"money",
	"money",
	"money",
	"money",
	"money",
	"money",
	"money",
	"money",
	"money",
	"money",
	"money",
	"money",
	"money",
	"pill"
]

var possible_roles = [
	"consumer",
	"visitor",
	"snowshoer",
	"cop"
]

var can_prefer = [
	"wistberry",
	"parrot",
	"purple_pleasure",
	"pill"
]
var cop_preference = [
	"wistberry",
	"parrot",
	"purple_pleasure"
]

var preference_corespondence = {
	"wistberry": load("res://Assets/Sprites/Glasse2.png"),
	"parrot": load("res://Assets/Sprites/Glasse1.png"),
	"purple_pleasure": load("res://Assets/Sprites/Glasse0.png"),
	"pill": load("res://Assets/Sprites/Pill0.png"),
	"money": load("res://Assets/Sprites/Coin0.png")
}

var _FSM
var _Skeleton
var _Head
var _Body
var _CollisionShape
var _IdeaBubble
var _AnimationPlayer

var rng = RandomNumberGenerator.new()

export(String) var role setget setRole
export(int) var contentment = 10

var prefer

var movement_target = null

var given_cocktail

func _ready():
	_FSM = $FSM
	_Skeleton = $Skeleton
	_Head = $Skeleton/Head
	_Body = $Skeleton/Body
	_CollisionShape = $CollisionShape
	_IdeaBubble = $IdeaBubble
	_AnimationPlayer = $AnimationPlayer
	rng = RandomNumberGenerator.new()
	rng.randomize()
	_generate_appearance()
	_generate_preference()

func _generate_role():
	role = possible_roles[rng.randi_range(0, possible_roles.size() - 1)]

func _generate_appearance():
	var min_range = 0 if role != "cop" else 6
	var max_range = 5 if role != "cop" else 8
	_Head.frame = rng.randi_range(0, _Head.frames.get_frame_count("default") - 1)
	_Body.frame = rng.randi_range(min_range, max_range)

func _generate_preference():
	match role:
		"cop":
			prefer = random_from(cop_preference)
		_:
			prefer = random_from(can_prefer)

func random_from(array: Array):
	return array[rng.randi_range(0, array.size() - 1)]

func setRole(role_name: String):
	role = role_name

func disable():
	visible = false

func enable():
	visible = true

func change_state_to(string: String):
	var target_state = _FSM.get_state(string)
	_FSM.change_state_to(target_state)

func display_idea():
	update_idea()
	_IdeaBubble.visible = true
	CtrlPlayerController.PlayerCamera.play_sound("Ask")

func update_idea():
	_IdeaBubble.get_node("Bubble/Sprite3D").texture = preference_corespondence[prefer]

func hide_idea():
	_IdeaBubble.visible = false

func pay():
	if given_cocktail != null and given_cocktail.ingredients.size() > 0:
		var ingredient = given_cocktail.ingredients[0] 
		if ingredient.ingredient_name == prefer:
			contentment += 2
		if ingredient.ingredient_name == "pill":
			contentment = round(contentment * 1.5)
	
	if contentment < 1:
		return
	
	var payment = {
		"money": 0,
		"pill": 0
	}
	for i in contentment:
		payment[random_from(resource_spread)] += 1
	
	for key in payment.keys():
		CtrlPlayerResources.spawn_resources(key, payment[key])
	CtrlPlayerController.PlayerCamera.play_sound("RecieveMoney")
