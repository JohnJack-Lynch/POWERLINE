class_name GrappleState
extends State

@export_group("States")
@export var ground_state : State
@export var air_state : State
@export var swing_state : State

@export_group("")
var start_swing = false

@export var pull_force : float

# timer will start when the player jumps
# if the timer runs out before the player hits the ground, the player will enter the swing state

func on_enter():
	pass

func state_process(delta):
	#print(swingTimer.get_time_left())
	
	var direction = Vector2()
	
	direction.x = Input.get_axis("PL_LEFT", "PL_RIGHT")
	
	#player.grappleBeam.grapple()
	if player.global_position.distance_to(player.grappleBeam.grapple_pos) > player.grappleBeam.slack:
		#player.velocity.x = 100 * -direction.x
		player.grappleBeam.is_grappling = false
	
	if player.grappleBeam.is_grappling == false and player.is_on_floor():
		next_state = ground_state
	elif player.grappleBeam.is_grappling == false and !player.is_on_floor():
		next_state = air_state
	

func state_input(event : InputEvent):
	if player.is_on_floor():
		pass
	
	if event.is_action_released("PL_SHOOT"):# or !player.grappleBeam.target_finder.aim_raycast.is_colliding():
		player.grappleBeam.is_grappling = false
	
	if Input.is_action_just_pressed("PL_ATTACK"):
		slingshot()
	

#func jump():
#	player.velocity.y = player.jump_force

func slingshot():
	var pull_dir = player.grappleBeam.grapple_dir
	var sling_force = (pull_dir * pull_force)
	
	player.velocity = sling_force
	
	player.grappleBeam.is_grappling = false
	
	next_state = air_state

func on_exit():
	player.reticle.visible = false
	
	player.grappleBeam.is_grappling = false
