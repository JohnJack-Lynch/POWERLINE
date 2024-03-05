extends Area2D

@export var player : Player

var grabable_entity : PhysicsBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("update_direction", _on_update_direction)

func _physics_process(delta):
	var entities := get_overlapping_bodies()
	
	if entities.size() != 0:
		grabable_entity = entities[0]

func get_grabable_entity():
	return grabable_entity != null

func _on_update_direction(facing_right : bool):
	if facing_right:
		scale.x = -1 
	else:
		scale.x = 1


func _on_body_exited(body):
	grabable_entity = null
