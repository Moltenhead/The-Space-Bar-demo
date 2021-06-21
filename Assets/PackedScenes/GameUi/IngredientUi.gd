extends Spatial

var selected_count
var selected

func select(i: int):
	deselect()
	selected = get_child(i-1)
	selected.selected = true
	return selected

func deselect():
	if not selected:
		return
	
	selected.selected = false

func set_selected(byte: int, boolean: bool):	
	match byte:
		1:
			get_child(0).selected = boolean
		2:
			get_child(1).selected = boolean
		4:
			get_child(2).selected = boolean
		3:
			for i in [0, 1]:
				get_child(i).selected = boolean
		5:
			for i in [0, 2]:
				get_child(i).selected = boolean
		6:
			for i in [1, 2]:
				get_child(i).selected = boolean
		7:
			for i in [0, 1, 2]:
				get_child(i).selected = boolean
	
	selected_count = get_selected().size()

func toggle_selected(byte: int):
	match byte:
		1:
			var child = get_child(0)
			child.selected = !child.selected
		2:
			var child = get_child(1)
			child.selected = !child.selected
		4:
			var child = get_child(2)
			child.selected = !child.selected
		3:
			for i in [0, 1]:
				var child = get_child(i)
				child.selected = !child.selected
		5:
			for i in [0, 2]:
				var child = get_child(i)
				child.selected = !child.selected
		6:
			for i in [1, 2]:
				var child = get_child(i)
				child.selected = !child.selected
		7:
			for i in [0, 1, 2]:
				var child = get_child(i)
				child.selected = !child.selected
	
	selected_count = get_selected().size()

func get_selected():
	var selected_children = []
	for child in get_children():
		if child.selected:
			selected_children.append(child)
	return selected_children
