class_name LaneSwitch
extends Area2D

@export_enum("foreground", "background", "toggle") var function

var in_foreground : bool = true

func _on_body_entered(body):
	if body is Player:
		match function:
			0: # foreground
				body.change_lane(true)
				in_foreground = true
				print("move to foreground")
			1: # background
				body.change_lane(false)
				in_foreground = false
				print("move to background")
			2: # toggle
				body.change_lane(!in_foreground)
				in_foreground = !in_foreground
				print("flip layer")
		print(in_foreground)
