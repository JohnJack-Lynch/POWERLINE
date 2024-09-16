class_name Player
extends CharacterBody2D

# physics calculations provided by the Sonic Physics Guide @ Sonic Retro

# -- MOVEMENT JUNK --

@export_category("Movement Values")
@export var base_speed : float
@export var accel_speed : float
@export var friction : float
@export var top_speed : float

@onready var air_accel : float = accel_speed * 1.5

@onready var slide_friction : float = friction / 3
@onready var air_friction : float = friction / 2
@onready var swing_friction : float = friction / 5
@onready var grind_friction : float = friction / 2

var cur_speed : float
var momentum : float

var direction : Vector2

var on_rail : bool = false

@export_subgroup("Slope Movement")
@export var slope_factor : float
@export var slope_factor_rolldown : float
@export var slope_factor_rollup : float

@export_subgroup("Jump Values")
@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descend : float

@onready var jump_force : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descend * jump_time_to_descend)) * -1.0

var buffered_jump : bool = false
var can_coyote_jump : bool = false

var wall_run_count : int

var enable_gravity : bool = true

# -- MISC STUFF --

var beam_shoot : bool = false
var dir_facing : int = 1 # 1 for right, -1 for left

var impact_dir : Vector2
var kb_dir : Vector2

var cur_path : Rail
var cur_rail : PathFollow2D

var no_hit : bool = false

var trick_active : bool = false

# -- OBJECT REFERENCES --

@export_category("Object References")

@export var grappleBeam : GrappleBeam

@onready var state_machine := $StateMachine

@onready var jumpBuffer := $JumpBuffer
@onready var coyoteTime := $CoyoteTimer

@onready var reticle := $Reticle

@onready var animController := $PlayerAnimController

@onready var health := $Health

# -- SIGNALS --

signal update_direction(facing_right : bool)

func _ready():
	no_hit = true

func _physics_process(delta):
	#velocity.x = clampf(velocity.x, -top_speed, top_speed)
	direction.x = Input.get_axis("PL_LEFT", "PL_RIGHT")
	
	# gravity
	if enable_gravity == true:#state_machine.cur_state.name != "WallRun":
		velocity.y += get_gravity() * delta
	
	velocity.y = min(velocity.y, get_gravity())
	
	if state_machine.cur_state.name == "WallSlide":
		velocity.y = min(velocity.y, 100)
	
	# movement
	if state_machine.check_if_can_move():
		movement(delta, direction.x)
	elif !state_machine.check_if_can_move() and velocity.x != 0:
		apply_friction(delta)
	
	if SettingsData.reticle_toggle:
		if grappleBeam.target_finder.is_targeting() and !grappleBeam.is_grappling:
			reticle.visible = true
		else:
			reticle.visible = false
		
		if reticle.visible:
			reticle.global_position = grappleBeam.target_finder.target.global_position
	
	
	move_and_slide()

func apply_acceleration(direction, delta): 
	velocity.x = move_toward(velocity.x, set_cur_speed(delta) * direction, accel_speed * delta)

func apply_friction(delta):
	if !is_on_floor():
		velocity.x = move_toward(velocity.x, 0, air_friction * delta)
		#print("air friction")
	elif state_machine.cur_state.name == "Slide":
		velocity.x = move_toward(velocity.x, 0, slide_friction * delta)
		#print("slide friction")
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

func set_cur_speed(delta):
	var cur_max_speed = abs(velocity.x)
	cur_speed = base_speed
	
	if cur_max_speed < base_speed:
		cur_max_speed = base_speed
	
	if is_on_slope():
		if get_floor_normal().x > 0:
			# going down left slope
			if velocity.x > 0:
				#print("going down left slope")
				cur_max_speed -= slope_factor * sin(get_floor_angle())
				
			elif velocity.x < 0:
				#print("going up left slope")
				cur_max_speed += (slope_factor * 10) * sin(get_floor_angle())
				
		elif get_floor_normal().x < 0:
			# going up right slope
			if velocity.x > 0:
				#print("going up right slope")
				cur_max_speed += (slope_factor * 10) * sin(get_floor_angle())
				
			elif velocity.x < 0:
				#print("going down right slope")
				cur_max_speed -= slope_factor * sin(get_floor_angle())
				
	
	return_to_base_speed(delta, cur_max_speed)
	
	return abs(cur_speed)

func return_to_base_speed(delta, cur_max_speed):
	momentum = cur_max_speed - base_speed
	
	if abs(velocity.x) > base_speed and is_on_floor():
		momentum = move_toward(momentum, 0, 10 * delta)
	cur_speed += momentum

func movement(delta, direction):
	if direction != 0 and (state_machine.cur_state.name != "Slide"):
		apply_acceleration(direction, delta)
	elif state_machine.cur_state.name != "Swing":
		apply_friction(delta)
	
	emit_signal("update_direction", !$Sprite2D.flip_h)
	
	jump()

func get_gravity():
	if velocity.y < 0:
		return jump_gravity
	else:
		return fall_gravity

func wall_on_left():
	return $LeftWallRaycast.is_colliding() or $LeftWallRaycast2.is_colliding()

func wall_on_right():
	return $RightWallRaycast.is_colliding() or $RightWallRaycast2.is_colliding()

func wall_check():
	return wall_on_left() or wall_on_right()

func is_on_slope():
	var flat_floor = Vector2(0, -1)
	
	return is_on_floor() and get_floor_normal() != flat_floor

func jump():
	if is_on_floor() or can_coyote_jump:
		if Input.is_action_just_pressed("PL_JUMP") or buffered_jump:
			velocity.y = jump_force
	else:
		if Input.is_action_just_released("PL_JUMP") and velocity.y < jump_force / 5:
			velocity.y = jump_force / 5
			
		if Input.is_action_just_pressed("PL_JUMP"):
			buffered_jump = true
			jumpBuffer.start()

func set_direction(value : float):
	direction.x  = value

func change_lane(in_foreground : bool):
	var fg_layer = 21
	var bg_layer = 37
	
	if !in_foreground:
		# set player's collision
		collision_mask = bg_layer
		z_index = -1
		
		# set wallcheck collision
		$LeftWallRaycast.collision_mask = 33
		$LeftWallRaycast2.collision_mask = 33
		$RightWallRaycast.collision_mask = 33
		$RightWallRaycast2.collision_mask = 33
		
		# set obsticle raycast collision
		$GrappleBeam/TargetFinder/ObstRaycast.collision_mask = 33
		
	else:
		collision_mask = fg_layer
		z_index = 0
		
		$LeftWallRaycast.collision_mask = 17
		$LeftWallRaycast2.collision_mask = 17
		$RightWallRaycast.collision_mask = 17
		$RightWallRaycast2.collision_mask = 17
		
		$GrappleBeam/TargetFinder/ObstRaycast.collision_mask = 17

func _on_jump_buffer_timeout():
	buffered_jump = false

func _on_coyote_timer_timeout():
	can_coyote_jump = false

func _on_invuln_timer_timeout():
	collision_layer = 4
