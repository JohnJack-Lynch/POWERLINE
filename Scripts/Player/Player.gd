class_name Player
extends CharacterBody2D

# physics calculations provided by the Sonic Physics Guide @ Sonic Retro

# -- MOVEMENT JUNK --

@export_group("Movement Values")
@export var base_speed : float
@export var accel_speed : float
@export var friction : float
@export var top_speed : float

@onready var air_accel : float = accel_speed * 1.5

@onready var slide_friction : float = friction / 3
@onready var air_friction : float = friction / 2
@onready var swing_friction : float = friction / 5

var cur_speed
var momentum

var direction

@export_subgroup("Slope Movement")
@export var slope_factor : float
@export var slope_factor_rolldown : float
@export var slope_factor_rollup : float

@export_group("Jump Values")
@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descend : float

@onready var jump_force : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descend * jump_time_to_descend)) * -1.0

var buffered_jump = false
var can_coyote_jump = false

# -- GRAPPLE CRAPPLE --

var beam_shoot = false
var dir_facing = 1 # 1 for right, -1 for left

# -- OBJECT REFERENCES --
@export_group("Object References")
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
	pass

func _physics_process(delta):
	direction = Vector2()
	
	direction.x = Input.get_axis("PL_LEFT", "PL_RIGHT")
	
	# gravity
	velocity.y += get_gravity() * delta
	velocity.y = min(velocity.y, get_gravity())
	
	if state_machine.cur_state.name == "WallSlide":
		velocity.y = min(velocity.y, 100)
	
	# movement
	if state_machine.check_if_can_move():
		movement(delta, direction.x)
	elif !state_machine.check_if_can_move() and velocity.x != 0:
		apply_friction(delta)
	velocity.x = clampf(velocity.x, -top_speed, top_speed)
	
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

func _on_jump_buffer_timeout():
	buffered_jump = false

func _on_coyote_timer_timeout():
	can_coyote_jump = false
