extends Label

@export var float_speed : Vector2 = Vector2(0, -150)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += float_speed * delta
	float_speed /= 1.5


func _on_timer_timeout():
	queue_free()
