class_name AirState
extends State

@export_group("States")
@export var ground_state : State
@export var wall_slide_state : State
@export var slide_state : State
@export var swing_state : State
#@export var attack_state : State
@export var hit_state : State

func on_enter():
	if player.velocity.y >= 0:
		player.coyoteTime.start()
		player.can_coyote_jump = true

func state_process(delta):
	if player.is_on_floor():
		next_state = ground_state
	elif player.wall_check() and !player.grappleBeam.beam_out:
		next_state = wall_slide_state
	
	if player.grappleBeam.is_grappling:
		next_state = swing_state

func state_input(event : InputEvent):
	if Input.is_action_just_pressed("PL_JUMP"):
		player.buffered_jump = true
		player.jumpBuffer.start()
	
	if Input.is_action_just_pressed("PL_JUMP") and player.can_coyote_jump:
		player.jump()
	
	if Input.is_action_just_released("PL_JUMP") and player.velocity.y < player.jump_force / 5:
		player.velocity.y = player.jump_force / 5
	
#	if Input.is_action_just_pressed("PL_ATTACK"):
#		attack()
	
	#if Input.is_action_just_pressed("PL_SHOOT"):
		#if player.grappleBeam.grapple_pos != null and player.grappleBeam.target_finder.aim_raycast.is_colliding():
			##player.grappleBeam.grapple()
			#player.grappleBeam.beam_out = true
			#await get_tree().create_timer(0.05).timeout
			#player.grappleBeam.is_grappling = true
		#else:
			#push_warning("No target detected. Staying in current state.")
	
	
	#if Input.is_action_just_pressed("PL_SHOOT"):
	#	next_state = swing_state

func coyote_jump():
	player.velocity.y = player.jump_force

#func attack():
#	next_state = attack_state

func on_exit():
	if Input.is_action_pressed("PL_DOWN"):
		next_state = slide_state
