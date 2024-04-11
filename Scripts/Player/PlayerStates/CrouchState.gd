class_name CrouchState
extends State

@export_group("")
@export var collsion_shape : CollisionShape2D

@export_group("States")
@export var ground_state : State
@export var slide_state : State

func on_enter():
	if player.velocity.x != 0:
		next_state = slide_state
	
	#collsion_shape.shape.height = 17
	#collsion_shape.position.y = 8.5

func state_process(delta):
	pass

func state_input(event):
	if event.is_action_released("PL_DOWN"):
		next_state = ground_state

func on_exit():
	pass
	#collsion_shape.shape.height = 34
	#collsion_shape.position.y = 0
