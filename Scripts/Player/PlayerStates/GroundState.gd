class_name GroundState
extends State

@export_category("States")
@export var skid_state : State
@export var air_state : State
@export var slide_state : State
@export var crouch_state : State
#@export var grab_state : State
@export var grapple_state : State
@export var rail_state : State
@export var hit_state : State

func on_enter():
	
	char.wall_run_count = 0
	
	if Input.is_action_pressed("PL_DOWN"):
		if abs(char.velocity.x) > 0:
			next_state = slide_state
		else:
			next_state = crouch_state
	
	%Hitbox.set_deferred("monitoring", false)

func state_process(delta):
	if !char.is_on_floor():
		next_state = air_state
	
	if char.grappleBeam.is_grappling:
		next_state = grapple_state
	
	if char.on_rail:
		next_state = rail_state
	

func state_input(event : InputEvent):
	if event.is_action_pressed("PL_DOWN"):
		if abs(char.velocity.x) > 0:
			next_state = slide_state
		else:
			next_state = crouch_state
	#if Input.is_action_just_pressed("PL_JUMP") or player.buffered_jump:
	#	player.jump()
	
#	if Input.is_action_just_pressed("PL_ATTACK"):
#		attack()
	
	#if event.is_action_pressed("PL_SHOOT"):
		#if player.grappleBeam.grapple_pos != null and player.grappleBeam.target_finder.aim_raycast.is_colliding():
			##player.grappleBeam.grapple()
			#player.grappleBeam.beam_out = true
			#await get_tree().create_timer(0.05).timeout
			#player.grappleBeam.is_grappling = true
	

func on_exit():
	pass
