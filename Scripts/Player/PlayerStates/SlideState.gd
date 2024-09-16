class_name SlideState
extends State

@export var collsion_shape : CollisionShape2D
@export var hitbox : Hitbox

@export_group("States")
@export var ground_state : State
@export var air_state : State
@export var crouch_state : State
@export var rail_state : State
@export var hit_state : State

@onready var slide_sound := $"../../SlideSound"

func on_enter():
	char.floor_stop_on_slope = false
	char.impact_dir = Vector2(0.25 * -char.dir_facing, -0.4)
	
	hitbox.position = Vector2((13 * char.dir_facing), 7)
	hitbox.rotation_degrees = 90
	if abs(char.velocity.x) >= 100:
		hitbox.set_deferred("monitoring", true)
	
	collsion_shape.shape.height = 17
	collsion_shape.position.y = 8.5
	
	slide_sound.playing = true

func state_process(delta):
	if Input.is_action_just_released("PL_DOWN"):
		next_state = ground_state
	
	if char.velocity.x == 0 and !char.is_on_slope():
		next_state = crouch_state
	
	#if char.velocity.x != 0:
	#	char.velocity.x = move_toward(char.velocity.x, 0, char.slide_friction)
	
	if char.on_rail and abs(char.velocity.x) > 150:
		next_state = rail_state
	
	var slope_dir : int
	
	if char.is_on_slope():
		if char.get_floor_normal().x > 0:
			slope_dir = -1
		elif char.get_floor_normal().x < 0:
			slope_dir = 1
		
		
		if slope_dir == -1 and char.velocity.x > 0 or slope_dir == 1 and char.velocity.x < 0:
			char.velocity.x = move_toward(char.velocity.x, char.top_speed * slope_dir, (char.slope_factor_rolldown * sin(char.get_floor_angle())) * delta)
		else:
			char.velocity.x = move_toward(char.velocity.x, char.top_speed * slope_dir, (char.slope_factor_rollup * sin(char.get_floor_angle())) * delta)
	
	

func state_input(event : InputEvent):
	if Input.is_action_just_pressed("PL_JUMP") or char.buffered_jump:
		jump()

func jump():
	char.velocity.y = char.jump_force
	next_state = air_state

func on_exit():
	char.floor_stop_on_slope = true
	
	hitbox.position = Vector2.ZERO
	hitbox.rotation_degrees = 0
	
	hitbox.set_deferred("monitoring", false)
	collsion_shape.shape.height = 34
	collsion_shape.position.y = 0
	
	slide_sound.playing = false


