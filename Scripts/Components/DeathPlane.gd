class_name DeathPlane
extends Area2D

@export var init_respawn_pos : Vector2
@export var player : Player

var respawn_pos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	respawn_pos = init_respawn_pos
	SignalBus.connect("update_respawn_pos", _on_update_respawn_pos)

func _on_update_respawn_pos(new_res_pos : Vector2):
	respawn_pos = new_res_pos

func _on_body_entered(body):
	body.velocity = Vector2.ZERO
	body.position = respawn_pos
