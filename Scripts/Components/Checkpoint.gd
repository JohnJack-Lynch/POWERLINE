class_name Checkpoint
extends Area2D

@export var respawn_pos : Vector2
@export var player : Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func get_respawn_pos():
	return respawn_pos

func _on_body_entered(body):
	SignalBus.emit_signal("update_respawn_pos", respawn_pos)
