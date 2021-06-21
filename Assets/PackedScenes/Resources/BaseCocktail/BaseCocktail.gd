tool

extends Spatial

export(Color) var base_color = Color(0.854902, 0.933333, 0.92549, 0.352941)
export(int) var max_ingredients = 1

var _CSGMesh
var mesh_material

var ingredients: Array = []

func _ready():
	_CSGMesh = $CSGMesh
	mesh_material = _CSGMesh.material
	reset()

func _set_mesh_color(color: Color):
	mesh_material.albedo_color = color

func _calculate_color_from_ingredients():
	if ingredients.size() < 1:
		return
	
	var temp_ingredients = ingredients.duplicate()
	var target_color = _get_color_from_ingredient(temp_ingredients.pop_front())
	for ingredient in temp_ingredients:
		var this_color = _get_color_from_ingredient(ingredient)
		target_color = target_color.blend(this_color)
	return target_color

func _get_color_from_ingredient(ingredient):
	return ingredient.cocktail_color

func add_ingredient(ingredient):
	if ingredient == null or ingredients.size() >= max_ingredients:
		return
	
	ingredients.append(ingredient)
	_set_mesh_color(_calculate_color_from_ingredients())

func reset():
	ingredients = []
	_set_mesh_color(base_color)
