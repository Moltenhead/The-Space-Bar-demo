extends Node

class PlayerResourceData:
	var _handler
	
	var resource_name: String
	var signal_name: String
	var is_essential: bool
	var is_consumable: bool
	var resource_min: int
	var resource_max: int
	var initial_value: int
	var associated_packed_scene: PackedScene
	
	var actual_value: int setget setActual_value
	
	func _init(params):
		_handler = params[0]
		resource_name = params[1]
		signal_name = "on_%s_update" % resource_name
		is_essential = params[2]
		is_consumable = params[3]
		if not is_consumable:
			return self
		
		resource_min = params[4]		# false is infinite
		resource_max = params[5]		# false is infinite
		initial_value = params[6]
		if params.size() > 7:
			associated_packed_scene = load(params[7])
		actual_value = initial_value
		return self
	
	func add(n = 1):
		if not is_consumable:
			return false
		
		if n != 0:
			return setActual_value(actual_value + n)
	
	func sub(n = 1):
		if not is_consumable:
			return false
		
		if n != 0:
			return setActual_value(actual_value - n)
	
	func pick_resource(amount: int = 1):
		if amount < 1:
			return
		
		if sub(amount):
			var instances = []
			for i in amount:
				instances.append(produce_instance())
			return instances
	
	func get_resource(amount: int = 1):
		var instances = []
		for i in amount:
			instances.append(produce_instance())
		return instances
	
	func produce_instance():
		return associated_packed_scene.instance()
	
	func setActual_value(value: int):
		if resource_min and value < resource_min:
			if is_essential:
				#TODO: trigger game_over
				return false
			
			actual_value = resource_min
			emit_update()
			return false
		
		if resource_max and value > resource_max:
			#TODO trigger max signal
			actual_value = resource_max
			emit_update()
			return false
		
		actual_value = value
		emit_update()
		return true
	
	func emit_update():
		_handler.emit_signal(signal_name, actual_value)

signal on_pill_update(value)
signal on_money_update(value)
signal on_glass_update(value)

var resources_config_data = [
	["money", true, true, false, false, 10, "res://Assets/PackedScenes/Resources/CatchableResource/Money.tscn"],
	["glass", false, true, 0, 3, 3],
	["pill", false, true, 0, 3, 1, "res://Assets/PackedScenes/Resources/CatchableResource/Pill.tscn"],
	["icecube", false, false, 0, 1, 1],
	["parrot", false, false, 0, 1, 1],
	["hemoglononbinar", false, 0, 1, 1],
	["purple_pleasure", false, 0, 1, 1],
	["wistberry", false, 0, 1, 1]
]

var resources_data = {}

func _ready():
	_set_player_data()

func _set_player_data():
	for resource_data in resources_config_data:
		resource_data.push_front(self)
		resources_data[resource_data[1]] = PlayerResourceData.new(resource_data)

func add_resource(resource_name: String, amount: int = 1):
	CtrlPlayerController.PlayerCamera.play_sound("TakeMoney")
	return resources_data[resource_name].add(amount)
func sub_resource(resource_name: String, amount: int = 1):
	return resources_data[resource_name].sub(amount)
func get_resource(resource_name: String, amount: int = 1):
	return resources_data[resource_name].get_resource(amount)
func resource_count(resource_name: String):
	return resources_data[resource_name].actual_value

func spawn_resources(resource_name: String, amount: int = 1):
	if CtrlPlayerController.is_active(0, "inactive"):
		return false
		
	var resources = resources_data[resource_name].get_resource(amount)
	for resource in resources:
		var spawn_location = CtrlPlayerController.PlayerCamera.give_spawnable_item_location()
		resource.translation = spawn_location
		CtrlPlayerController.PlayerCamera._InteractionShape.add_child(resource)
