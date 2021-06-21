extends Node2D

export(Font) var font
export(Color) var font_color
export(Texture) var pill_texture
export(float) var texture_rect_ratio = 0.05
export(float) var ui_margin_ratio = 0.01
export(float) var progress_bar_up_margin_ratio = 0.1

var _Coin
var _GlassesContainer
var _PillsContainer
var _ShakeProgressBar

var _margin_size
var _texture_size
var _texture_scale
var _coin_text_position

var _money_string = ""

func _ready():
	_Coin = $Coin
	_GlassesContainer = $GlassesContainer
	_PillsContainer = $PillsContainer
	_ShakeProgressBar = $ShakeProgressBar
	_scale_ui()
	
	CtrlPlayerResources.connect("on_money_update", self, "_update_coins")
	CtrlPlayerResources.connect("on_pill_update", self, "_update_pills")
	CtrlPlayerResources.connect("on_glass_update", self, "_update_glasses")
	
	CtrlPlayerController.connect("on_state_change", self, "_update_display")
	_add_one_pill()
	update()

func _draw():
	if not CtrlPlayerController.is_active(0, "inactive"):
		draw_string(font, _coin_text_position, _money_string, font_color)

func _scale_ui():
	var window_size = OS.window_size
	_texture_size = window_size.y * texture_rect_ratio
	_margin_size = window_size.y * ui_margin_ratio
	var rect_size = _Coin.rect_size.x
	_texture_scale = _texture_size / rect_size
	_Coin.rect_scale = Vector2(_texture_scale, _texture_scale)
	_Coin.rect_position = Vector2(_margin_size, _margin_size)
	
	var i = 0
	for container in [_GlassesContainer, _PillsContainer]:
		container.rect_scale = Vector2(_texture_scale, _texture_scale) * 0.8
		container.rect_position = Vector2(_margin_size, (_margin_size + _texture_size) * (i + 2))
		i += 1
	
	_coin_text_position = Vector2(_margin_size * 2 + _texture_size, _margin_size + _texture_size / 2 + font.get_height() / 2.5)
	
	_update_progress_bar_position(window_size)

func _update_progress_bar_position(window_size):
	var h_position = (window_size.x - _ShakeProgressBar.texture.get_width()) / 2
	_ShakeProgressBar.rect_position = Vector2(h_position, window_size.y * progress_bar_up_margin_ratio)

func _update_display(_state_name):
	_update_coins(CtrlPlayerResources.resource_count("money"))

func _update_coins(amount):
	_money_string = "x %s" % amount
	update()

func _update_pills(amount):
	var pills_count = _PillsContainer.get_child_count()
	if amount == pills_count:
		return
	
	if amount < pills_count:
		return _remove_one_pill()
	
	return _add_one_pill()

func _remove_one_pill():
	var count = _PillsContainer.get_child_count()
	if count < 1:
		return
	
	var target_pill = _PillsContainer.get_child(count - 1)
	_PillsContainer.remove_child(target_pill)
	target_pill.queue_free()

func _add_one_pill():
	var texture = TextureRect.new()
	texture.texture = pill_texture
	_PillsContainer.add_child(texture)

#func _update_glasses(amount):
#	#TODO
#	pass
