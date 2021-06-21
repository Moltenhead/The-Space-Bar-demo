extends Node

func execute(state, target, delta):
	var player = target.PlayerCamera._PlayerHands._AnimationPlayer
	if player.current_animation_length < player.current_animation_position:
		return
