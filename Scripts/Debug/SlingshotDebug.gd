extends Label

@export var grapple_beam : GrappleBeam

# copy over from the swing/grapple states
@export var pull_force : float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pull_dir = grapple_beam.grapple_dir
	var sling_force = pull_dir * pull_force
	
	text = "Sling Force: " + str(sling_force)
