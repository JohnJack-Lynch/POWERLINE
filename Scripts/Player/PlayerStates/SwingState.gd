class_name SwingState
extends State

@export_group("States")
@export var ground_state : State
@export var air_state : State
@export var grapple_state : State
@export var wall_slide_state : State
@export var hit_state : State

@export_group("")
@export var pull_force : float

@onready var hitbox := %Hitbox

func on_enter():
	pass

func state_process(delta):
	#char.grappleBeam.grapple()
	char.grappleBeam.swing(delta)
	#char.grappleBeam.dampen(delta)
	
	#char.velocity.y = clamp(char.velocity.y, char.jump_force, 600)
	
	#swinging_movement(delta)
	
	if char.is_on_floor():# or abs(char.velocity.x) < 0.01:
		char.grappleBeam.is_grappling = false
	
	if char.global_position.distance_to(char.grappleBeam.grapple_pos) > char.grappleBeam.slack:
		char.grappleBeam.is_grappling = false
	
	if char.grappleBeam.is_grappling == false:
		if char.is_on_floor():
			next_state = ground_state
		else:
			next_state = air_state
	
	if char.wall_check():# and char.velocity.y < 0:
		next_state = wall_slide_state
	

func state_input(event : InputEvent):
	if event.is_action_released("PL_SHOOT"):
		char.grappleBeam.is_grappling = false
	
	if Input.is_action_just_pressed("PL_ATTACK"):
		slingshot()
	
	#if direction.x > 0:
	#	char.velocity.x = swing_force
	#elif direction.x < 0:
	#	char.velocity.x = -swing_force
	

#func swinging_movement(delta):
#	var direction = Vector2()
#	direction.x = Input.get_axis("PL_LEFT", "PL_RIGHT")

func slingshot():
	var pull_dir = char.grappleBeam.grapple_dir
	var sling_force = (pull_dir * pull_force) 
	char.impact_dir = Vector2(char.grappleBeam.grapple_dir.y, char.grappleBeam.grapple_dir.x)
	
	char.velocity = sling_force
	
	char.grappleBeam.is_grappling = false
	
	next_state = air_state
	
	hitbox.set_deferred("monitoring", true)
	
	$"../../Hitbox/ActiveTimer".start()

func on_exit():
	#char.reticle.visible = false
	
	char.grappleBeam.is_grappling = false
	
	char.velocity *= 1.1


