class_name RailState
extends State

@export_category("States")
@export var ground_state : State
@export var jump_state : State
@export var air_state : State

@export_group("Stats")
@export var exit_vel : float = 200.0

var grind_vel : float

var init_vel : float
var final_vel : float

var progress : float

var crouch_active : bool = false

func on_enter():
	init_vel = char.velocity.x
	
	grind_vel = init_vel
	
	char.enable_gravity = false
	char.velocity = Vector2.ZERO 

func state_process(delta):
	var rail_angle : float = char.rotation * (-char.dir_facing)
	
	grind_vel = clampf(grind_vel, -1000.0, 1000.0)
	
	progress = char.cur_rail.progress_ratio
	
	final_vel = grind_vel
	
	if !char.on_rail:
		next_state = air_state
	
	char.cur_rail.progress += (grind_vel * delta)
	
	# just an idea but what if the angle of the rail was determined by the player's rotation
	# (basically the reverse of the slope check)
	# negative is going down, positive is going up
	
	if rail_slope_check():
		if rail_angle > 0: # going up
			if crouch_active:
				grind_vel -= (char.slope_factor * 1.33) * rail_angle
			else:
				grind_vel -= char.slope_factor * rail_angle
		elif rail_angle < 0: # going down
			if crouch_active:
				grind_vel += (char.slope_factor * 1.33) * rail_angle
			else:
				grind_vel += char.slope_factor * rail_angle
	
	if (progress >= 0.99 and char.dir_facing == 1) or (progress <= 0.01 and char.dir_facing == -1):
		char.velocity.y = -exit_vel
		char.velocity.x = final_vel
		#char.position.y -= 1
		next_state = air_state
	#if char.velocity == Vector2.ZERO:
		#next_state = air_state
	
	#print(rail_vel)

func state_input(event):
	if event.is_action_pressed("PL_JUMP"):
		char.velocity.x = final_vel
		char.on_rail = false
		next_state = air_state
		char.jump()
	
	if event.is_action_pressed("PL_ATTACK"):
		crouch_active = true
	elif event.is_action_released("PL_ATTACK"):
		crouch_active = false
		# crouch to gain speed on slopes

func rail_slope_check() -> bool:
	if char.rotation != 0:
		return true
	else:
		return false

func on_exit():
	#char.velocity.x = final_vel
	#char.position.x += (1 * char.dir_facing)
	#char.position.y -= 1
	char.rotation = 0
	char.enable_gravity = true
	
