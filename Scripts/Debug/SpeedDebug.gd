extends Label

@export var player : Player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "Velocity: " + str(player.velocity)
