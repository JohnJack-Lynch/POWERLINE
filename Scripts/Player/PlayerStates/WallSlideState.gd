class_name WallSlideState
extends State

@export var wall_jump_force : Vector2

@export_group("States")
@export var ground_state : State
@export var air_state : State

func on_enter():
	player.animController.sprite.flip_h = player.wall_on_left()
	player.grappleBeam.is_grappling = false


func state_process(delta):
	if !player.wall_check():
		
		if player.is_on_floor():
			next_state = ground_state
		else:
			next_state = air_state
	elif player.is_on_floor():
		next_state = ground_state

func state_input(event : InputEvent):
	if Input.is_action_just_pressed("PL_JUMP") or player.buffered_jump:
		if player.wall_on_left():
			player.velocity.x = wall_jump_force.x
			player.velocity.y = wall_jump_force.y
		elif player.wall_on_right():
			player.velocity.x = -wall_jump_force.x
			player.velocity.y = wall_jump_force.y
