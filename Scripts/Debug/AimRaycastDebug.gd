extends Label

@export var grapple_beam : GrappleBeam


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if grapple_beam.is_grappling:
		text = "Is Grappling: true"
	else:
		text = "Is Grappling: false"
