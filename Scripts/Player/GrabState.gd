class_name GrabState
extends State

@export_group("States")
@export var ground_state : State
@export var air_state : State

@export_group("")
@export var throw_force : float
@export var grab_box : Area2D

var grabbed_entity : PhysicsBody2D
var is_rigidbody : bool = false

func on_enter():
	grabbed_entity = grab_box.grabable_entity
	grab_box.monitoring = false
	grab_box.set_physics_process(false)
	
	if grabbed_entity.is_class("RigidBody2D"):
		is_rigidbody = true

func state_process(delta):
	grabbed_entity.global_position = Vector2(player.global_position.x, (player.global_position.y - 20))
	
	if is_rigidbody:
		grabbed_entity.freeze = true
	else:
		pass

func state_input(event : InputEvent):
	if Input.is_action_just_pressed("PL_GRAB"):
		if is_rigidbody:
			grabbed_entity.freeze = false
			grabbed_entity.apply_central_impulse(Vector2(throw_force * player.dir_facing, -100))
		else:
			grabbed_entity.velocity.x = throw_force
		
		if !player.is_on_floor():
			next_state = air_state
		else:
			next_state = ground_state
	
	if Input.is_action_just_pressed("PL_JUMP") and !player.is_on_floor():
		if is_rigidbody:
			grabbed_entity.freeze = false
			grabbed_entity.apply_central_impulse(Vector2(0, throw_force))
		
		player.velocity.y = -throw_force
		next_state = air_state
	

func on_exit():
	grabbed_entity = null
	grab_box.set_physics_process(true)
	grab_box.monitoring = true
