class_name Enemy
extends CharacterBody2D

@export var idle_speed : int
@export var follow_speed : int

@export var weight : float

@export var target_finder : TargetFinder

@export var hit_state : State

@onready var state_machine := $StateMachine

@onready var animController := $EnemyAnimController

@onready var health := $Health

var direction = Vector2.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal update_direction(facing_right : bool)

func _ready():
	randomize()

func _physics_process(delta):
	var cur_speed : int
	var facing_dir : int
	
	if state_machine.cur_state.name == "LockOn":
		cur_speed = follow_speed
	else:
		cur_speed = idle_speed
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if direction and state_machine.check_if_can_move():
		velocity.x = direction.x * cur_speed
	elif state_machine.cur_state.name == "Hit":
		velocity.x = move_toward(velocity.x, 0, cur_speed)
	
	if !$Sprite2D.flip_h:
		facing_dir = 1
	else:
		facing_dir = -1
	
	target_finder.default_pos = Vector2(target_finder.bounds.shape.radius * facing_dir, 0)
	
	emit_signal("update_direction", !$Sprite2D.flip_h)
	
	move_and_slide()
