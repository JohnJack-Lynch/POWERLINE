extends Label

@export var grapple_beam : GrappleBeam

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "Grapple Pos: " + str(grapple_beam.grapple_pos)
