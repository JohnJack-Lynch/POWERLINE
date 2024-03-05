extends Label

@export var target_finder : TargetFinder

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target_finder.target != null:
		text = "Current Target: " + target_finder.target.name
	#elif grapple_beam.target_finder.aim_raycast.is_colliding():
	#	text = "Current Target: Wall"
	else:
		text = "Current Target: (null)"
