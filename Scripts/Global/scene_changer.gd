extends Node

var cur_scene = null

func _ready():
	var root = get_tree().root
	cur_scene = root.get_child(root.get_child_count() - 1)

func switch_scene(path):
	call_deferred("_deferred_switch_scene", path)

func _deferred_switch_scene(path):
	cur_scene.free()
	var s = load(path)
	cur_scene = s.instantiate()
	get_tree().root.add_child(cur_scene)
	get_tree().current_scene = cur_scene
