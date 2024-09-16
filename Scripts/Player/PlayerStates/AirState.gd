class_name AirState
extends State

@export_category("States")
@export var ground_state : State
@export var wall_slide_state : State
@export var slide_state : State
#@export var grab_state : State
@export var swing_state : State
@export var rail_state : State
@export var hit_state : State

@onready var land_sound := $"../../LandSound"

func on_enter():
	if char.velocity.y >= 0:
		char.coyoteTime.start()
		char.can_coyote_jump = true

func state_process(delta):
	if char.is_on_floor():
		next_state = ground_state
	elif char.wall_check() and !char.grappleBeam.beam_out:
		#if char.velocity.y < 0:
			#next_state = wall_run_state
		#else:
		next_state = wall_slide_state
	
	if char.grappleBeam.is_grappling:
		next_state = swing_state
	
	if char.on_rail and abs(char.velocity.x) > 150:
		next_state = rail_state

func state_input(event : InputEvent):
	if Input.is_action_just_pressed("PL_JUMP"):
		char.buffered_jump = true
		char.jumpBuffer.start()
	
	if Input.is_action_just_pressed("PL_JUMP") and char.can_coyote_jump:
		char.jump()
	
	if Input.is_action_just_released("PL_JUMP") and char.velocity.y < char.jump_force / 5:
		char.velocity.y = char.jump_force / 5
	
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
	char.velocity.y = char.jump_force

func on_exit():
	%Hitbox.set_deferred("monitoring", false)
	
	if Input.is_action_pressed("PL_DOWN"):
		next_state = slide_state
	
	if next_state == ground_state or next_state == slide_state:
		land_sound.play()


func _on_active_timer_timeout():
	%Hitbox.set_deferred("monitoring", false)
