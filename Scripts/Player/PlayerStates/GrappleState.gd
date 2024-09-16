class_name GrappleState
extends State

@export_group("States")
@export var ground_state : State
@export var air_state : State
@export var swing_state : State
@export var launch_state : State
@export var hit_state : State

@export_group("")
var start_swing = false

@export var pull_force : float

@onready var hitbox := %Hitbox

# timer will start when the char jumps
# if the timer runs out before the char hits the ground, the char will enter the swing state

func on_enter():
	pass

func state_process(delta):
	#print(swingTimer.get_time_left())
	
	var direction = Vector2()
	
	direction.x = Input.get_axis("PL_LEFT", "PL_RIGHT")
	
	#char.grappleBeam.grapple()
	if char.global_position.distance_to(char.grappleBeam.grapple_pos) > char.grappleBeam.slack:
		#char.velocity.x = 100 * -direction.x
		char.grappleBeam.is_grappling = false
	
	if char.grappleBeam.is_grappling == false and char.is_on_floor():
		next_state = ground_state
	elif char.grappleBeam.is_grappling == false and !char.is_on_floor():
		next_state = air_state
	

func state_input(event : InputEvent):
	if char.is_on_floor():
		pass
	
	if event.is_action_released("PL_SHOOT"):# or !char.grappleBeam.target_finder.aim_raycast.is_colliding():
		char.grappleBeam.is_grappling = false
	
	if Input.is_action_just_pressed("PL_ATTACK"):
		slingshot()
	

#func jump():
#	char.velocity.y = char.jump_force

func slingshot():
	var pull_dir = char.grappleBeam.grapple_dir
	var sling_force = (pull_dir * pull_force)
	char.impact_dir = char.grappleBeam.grapple_dir
	
	char.velocity = sling_force
	
	char.grappleBeam.is_grappling = false
	
	next_state = air_state
	
	hitbox.set_deferred("monitoring", true)
	$"../../Hitbox/ActiveTimer".start()
	

func on_exit():
	#char.reticle.visible = false
	
	char.grappleBeam.is_grappling = false
