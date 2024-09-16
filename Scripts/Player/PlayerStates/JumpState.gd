class_name JumpState
extends State

@export var ground_state : State
@export var air_state : State
@export var wall_slide_state : State
@export var swing_state : State
@export var hit_state : State

@onready var jump_sound := $"../../JumpSound"

func on_enter():
	char.jump()
	jump_sound.play()

func state_process(delta):
	if char.velocity.y > 0:
		next_state = air_state

func state_input(event):
	pass

func on_exit():
	pass
