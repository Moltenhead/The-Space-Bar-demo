tool

extends Spatial

export(PackedScene) var ingredient
export(float) var ingredient_texture_scale = 1

var ingredient_instance
var prev_ingredient
var prev_scale

var _Background
var _IngredientDisplay

var selected: bool setget _setSelected

func _ready():
	_Background = $Background
	_IngredientDisplay = $Background/IngredientDisplay
	_update_ingredient_instance()
	_update_scale()
	_update_texture()

func _setSelected(boolean: bool):
	selected = boolean
	if boolean:
		CtrlPlayerController.PlayerCamera.play_sound("Select")
	_Background.frame = int(boolean)

func _update_ingredient_instance():
	ingredient_instance = ingredient.instance()

func _update_scale():
	_IngredientDisplay.scale = Vector3(ingredient_texture_scale, ingredient_texture_scale, 1)

func _update_texture():
	_IngredientDisplay.texture = ingredient_instance.ingredient_texture

func get_cocktail_color():
	return ingredient_instance.cocktail_color

func get_ingredient():
	return ingredient_instance
