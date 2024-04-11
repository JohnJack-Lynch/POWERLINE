class_name SwingState
extends State

@export_group("States")
@export var ground_state : State
@export var air_state : State
@export var grapple_state : State

@export_group("")
@export var pull_force : float

func on_enter():
	pass

func state_process(delta):
	#player.grappleBeam.grapple()
	player.grappleBeam.swing(delta)
	#player.grappleBeam.dampen(delta)
	
	#player.velocity.y = clamp(player.velocity.y, player.jump_force, 600)
	
	#swinging_movement(delta)
	
	if player.is_on_floor():# or abs(player.velocity.x) < 0.01:
		player.grappleBeam.is_grappling = false
	
	if player.global_position.distance_to(player.grappleBeam.grapple_pos) > player.grappleBeam.slack:
		player.grappleBeam.is_grappling = false
	
	if player.grappleBeam.is_grappling == false:
		if player.is_on_floor():
			next_state = ground_state
		else:
			next_state = air_state
	

func state_input(event : InputEvent):
	if event.is_action_released("PL_SHOOT"):
		player.grappleBeam.is_grappling = false
	
	if Input.is_action_just_pressed("PL_ATTACK"):
		slingshot()
	
	#if direction.x > 0:
	#	player.velocity.x = swing_force
	#elif direction.x < 0:
	#	player.velocity.x = -swing_force
	

#func swinging_movement(delta):
#	var direction = Vector2()
#	direction.x = Input.get_axis("PL_LEFT", "PL_RIGHT")

func slingshot():
	var pull_dir = player.grappleBeam.grapple_dir
	var sling_force = (pull_dir * pull_force) 
	
	player.velocity = sling_force
	
	player.grappleBeam.is_grappling = false
	
	next_state = air_state

func on_exit():
	player.reticle.visible = false
	
	player.grappleBeam.is_grappling = false
	
	player.velocity *= 1.1


