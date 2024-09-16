class_name DeathState
extends State

@export var ground_state : State
@export var health : Health

var respawn_pos : Vector2

func _ready():
	SignalBus.connect("update_respawn_pos", _on_update_respawn_pos)

func on_enter():
	char.global_position = respawn_pos
	next_state = ground_state

func _on_update_respawn_pos(new_res_pos : Vector2):
	respawn_pos = new_res_pos

func on_exit():
	
	
	health.health = 100
	char.velocity = Vector2.ZERO
