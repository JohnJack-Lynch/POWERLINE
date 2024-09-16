class_name WallSlideState
extends State

@export var wall_jump_force : Vector2

@export var boost_force : float

@export_category("States")
@export var ground_state : State
@export var air_state : State
@export var hit_state : State

@onready var slide_sound = $"../../SlideSound"

func on_enter():
	char.animController.sprite.flip_h = char.wall_on_left()
	char.grappleBeam.is_grappling = false
	
	slide_sound.playing = true


func state_process(delta):
	if !char.wall_check():
		
		if char.is_on_floor():
			next_state = ground_state
		else:
			next_state = air_state
	elif char.is_on_floor():
		next_state = ground_state

func state_input(event : InputEvent):
	if Input.is_action_just_pressed("PL_JUMP") or char.buffered_jump:
		if char.wall_on_left():
			char.velocity.x = wall_jump_force.x
			char.velocity.y = wall_jump_force.y
		elif char.wall_on_right():
			char.velocity.x = -wall_jump_force.x
			char.velocity.y = wall_jump_force.y
	
	if event.is_action_pressed("PL_UP"):
		char.velocity.y = -boost_force

func on_exit():
	slide_sound.playing = false
