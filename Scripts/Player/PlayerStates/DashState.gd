class_name DashState
extends State

@export_category("")
@export var dash_force : float
@export var dash_timer : Timer

@export_category("States")
@export var ground_state : State
@export var air_state : State

func on_enter():
	dash_timer.start()

func state_process(delta):
	pass

func state_input(event):
	pass

func on_exit():
	pass

func _on_dash_timer_timeout():
	if !char.is_on_floor():
		next_state = air_state
	else:
		next_state = ground_state
