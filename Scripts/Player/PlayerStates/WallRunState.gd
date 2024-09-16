class_name WallRunState
extends State

@export var wall_jump_force : Vector2
@export var wall_run_decel_rate : float
@export var consec_boost : float

@export_group("States")
@export var air_state : State
@export var wall_slide_state : State
@export var swing_state : State
@export var hit_state : State

func on_enter():
	char.enable_gravity = false
	
	char.wall_run_count += 1
	
	char.grappleBeam.is_grappling = false
	
	char.velocity.y -= (consec_boost * char.wall_run_count)

func state_process(delta):
	if char.velocity.y >= 0:
		next_state = wall_slide_state
	
	if char.wall_check() == false:
		next_state = air_state
	
	wall_movement(wall_run_decel_rate, delta)

func state_input(event : InputEvent):
	if event.is_action_pressed("PL_JUMP"):
		if char.wall_on_left():
			char.velocity.x = wall_jump_force.x
			char.velocity.y = wall_jump_force.y
		elif char.wall_on_right():
			char.velocity.x = -wall_jump_force.x
			char.velocity.y = wall_jump_force.y

func wall_movement(rate, delta):
	char.velocity.y = move_toward(char.velocity.y, 0, rate * delta)

func on_exit():
	char.enable_gravity = true
