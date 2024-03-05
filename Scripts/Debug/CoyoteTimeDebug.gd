extends Label

@export var player : Player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.can_coyote_jump:
		text = "Coyote Jump: true"
	else:
		text = "Coyote Jump: false"
