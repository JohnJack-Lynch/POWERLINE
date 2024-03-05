extends Label

@export var player : Player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.buffered_jump:
		text = "Buffering Jump: true"
	else:
		text = "Buffering Jump: false"
