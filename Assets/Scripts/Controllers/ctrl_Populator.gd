extends Node

var population_tendencies = [
	"consumer",
	"consumer",
	"consumer",
	"consumer",
	"consumer",
	"consumer",
	"cop",
	"cop",
	"visitor",
	"visitor",
	"visitor",
	"visitor",
	"visitor",
	"visitor",
	"visitor",
	"visitor",
	"snowshoer"
]

var test_population_tendencies = [
	"consumer"
]

var role_to_actor = {
	"consumer":		preload("res://Assets/PackedScenes/Actors/ConsumerActor.tscn"),
	"visitor": 		preload("res://Assets/PackedScenes/Actors/VisitorActor.tscn"),
	"cop": 			preload("res://Assets/PackedScenes/Actors/CopActor.tscn"),
	"snowshoer": 	preload("res://Assets/PackedScenes/Actors/SnowshoerActor.tscn")
}

var world
var spawn_position

var meeting_place
var meeting_queue

var walking_area

var awaiting_consumers = []
var actual_consumer setget _setActual_consumer

var rng

var spawn_interval = 2.0
var spawn_count = 0
var max_spawned = 1

var timer = 0
var global_timer = 0

var cop_count = 0

var upkeep_cost_ratio = 0.3

func _ready():
	rng = RandomNumberGenerator.new()

func _process(delta):
	if CtrlPlayerController.is_active(0, "inactive"):
		return
	
	global_timer += delta
	if spawn_count >= max_spawned:
		return
	
	timer += delta
	if timer < spawn_interval:
		return
	
	timer = 0
	spawn_random_new_actor()

func spawn_random_new_actor(_params = null):
	var new_actor = _generate_actor()
	world.add_child(new_actor)
	spawn_count += 1
	new_actor.global_translate(spawn_position)
	new_actor.enable()
	
	if new_actor.role == "cop":
		cop_count += 1
		return
	
	if new_actor.role == "consumer":
		if !actual_consumer and awaiting_consumers.size() < 1:
			_setActual_consumer(new_actor)
			return
		
		awaiting_consumers.append(new_actor)
		new_actor.change_state_to("GoToQueue")
	
	if spawn_count >= max_spawned:
		set_process(false)

func _generate_actor():
	var data_spread = population_tendencies
	if GameState.debug:
		data_spread = test_population_tendencies
	var role = random_from(data_spread)
	return role_to_actor[role].instance()

func random_from(array: Array):
	rng.randomize()
	return array[rng.randi_range(0, array.size() - 1)]

func request_next_consumer():
	_setActual_consumer(awaiting_consumers.pop_front())

func get_random_walking_position():
	rng.randomize()
	var random_collision = walking_area.get_child(rng.randi_range(0, walking_area.get_child_count() - 1))
	var collision_origin = Vector3(random_collision.get_global_transform().origin)
	var extents = random_collision.shape.extents
	rng.randomize()
	var rand_x = rng.randf_range(-extents.x, extents.x)
	rng.randomize()
	var rand_y = rng.randf_range(-extents.y, extents.y)
	return collision_origin + Vector3(rand_x, 0,rand_y)

func get_upkeep():
	return round(global_timer * 0.3)

# SET/GET
func _setActual_consumer(consumer):
	print("in actual_consumer setter with %s" % consumer)
	actual_consumer = consumer
	if actual_consumer != null:
		actual_consumer.change_state_to("GoToBar")
