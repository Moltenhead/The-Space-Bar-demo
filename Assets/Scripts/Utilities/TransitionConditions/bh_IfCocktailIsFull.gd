extends Node

func execute(controller, _state):
	return controller.PlayerCamera._Cocktail.ingredients.size() >= controller.PlayerCamera._Cocktail.max_ingredients
