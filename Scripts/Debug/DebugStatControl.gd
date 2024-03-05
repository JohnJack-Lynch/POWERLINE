extends Control

func _ready():
	visible = false

func _process(delta):
	if OS.is_debug_build():
		if Input.is_action_just_pressed("DEBUG_STATS") and visible:
			visible = false
		elif Input.is_action_just_pressed("DEBUG_STATS") and !visible:
			visible = true
