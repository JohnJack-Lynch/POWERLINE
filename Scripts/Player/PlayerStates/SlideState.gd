class_name SlideState
extends State

@export_group("")
@export var collsion_shape : CollisionShape2D

@export_group("States")
@export var ground_state : State
@export var air_state : State
@export var crouch_state : State

func on_enter():
	player.floor_stop_on_slope = false
	
	#collsion_shape.shape.height = 17
	#collsion_shape.position.y = 8.5

func state_process(delta):
	if Input.is_action_just_released("PL_DOWN"):
		next_state = ground_state
	
	if player.velocity.x == 0 and !player.is_on_slope():
		next_state = crouch_state
	
	#if player.velocity.x != 0:
	#	player.velocity.x = move_toward(player.velocity.x, 0, player.slide_friction)
	
	var slope_dir : int
	
	if player.is_on_slope():
		if player.get_floor_normal().x > 0:
			slope_dir = -1
		elif player.get_floor_normal().x < 0:
			slope_dir = 1
		
		
		if slope_dir == -1 and player.velocity.x > 0 or slope_dir == 1 and player.velocity.x < 0:
			player.velocity.x = move_toward(player.velocity.x, player.top_speed * slope_dir, (player.slope_factor_rolldown * sin(player.get_floor_angle())) * delta)
		else:
			player.velocity.x = move_toward(player.velocity.x, player.top_speed * slope_dir, (player.slope_factor_rollup * sin(player.get_floor_angle())) * delta)
	
	

func state_input(event : InputEvent):
	if Input.is_action_just_pressed("PL_JUMP") or player.buffered_jump:
		jump()

func on_exit():
	player.floor_stop_on_slope = true
	
	#collsion_shape.shape.height = 34
	#collsion_shape.position.y = 0

func jump():
	player.velocity.y = player.jump_force
	next_state = air_state
