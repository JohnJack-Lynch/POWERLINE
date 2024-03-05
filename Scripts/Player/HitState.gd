class_name HitState
extends State

@export_group("States")
@export var return_state : State
@export var death_state : State

@export_group("")
@export var health : Health
@export var timer : Timer

func _ready():
	health.connect("on_hit", _health_on_hit)

func on_enter():
	player.direction = Vector2.ZERO
	timer.start()

func state_process(delta):
	if player.is_on_floor():
		next_state = return_state

func on_exit():
	pass

func _health_on_hit(node : Node, damage : int):
	if player.health.get_cur_health() > 0:
		emit_signal("interrupt_state", self)
#	else:
#		emit_signal("interrupt_state", death_state)


func _on_timer_timeout():
	next_state = return_state
