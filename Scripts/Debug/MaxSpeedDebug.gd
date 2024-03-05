extends Label

@export var player : Player
var max_speed = 250

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if abs(player.velocity.x) > max_speed:
		max_speed = abs(player.velocity.x)
	
	text = "Cur Max Speed: " + str(max_speed)
