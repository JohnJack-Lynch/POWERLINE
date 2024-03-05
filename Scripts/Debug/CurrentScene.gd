extends Label

#@export var state_machine : PlayerStateMachine

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "Scene: " + get_tree().get_current_scene().get_name()
