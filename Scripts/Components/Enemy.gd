class_name Enemy
extends CharacterBody2D

@export var shooting_type : bool = false

@export_category("Enemy Stats")
@export var health_override : float
@export var damage_override : float
@export var kill_points : int

@export var idle_speed : int
@export var follow_speed : int

@export_category("Object References")
@export var target_finder : TargetFinder

@export var hit_state : State

@onready var state_machine := $StateMachine
@onready var animController := $EnemyAnimController
@onready var health := $Health
@onready var hitbox := %Hitbox

var direction = Vector2.ZERO

var impact_dir : Vector2 
var kb_dir : Vector2

var can_attack : bool = true

signal update_direction(facing_right : bool)

func _ready():
	randomize()
	
	if health_override != 0:
		health.health = health_override
	
	if damage_override != 0:
		hitbox.damage = damage_override

func freeze(toggle : bool):
	if toggle:
		set_physics_process(false)
		state_machine.set_physics_process(false)
	else:
		set_physics_process(true)
		state_machine.set_physics_process(true)

func _on_jump_box_body_entered(body):
	if body is Player:
		#if body.global_position.y < $JumpBox.global_position.y:
			#print("true")
		if body.velocity.y > 0:
			body.velocity.y = (-body.velocity.y * 1.2)
			health.hit(1, Vector2(0, 500), Vector2.DOWN)

func _on_invuln_timer_timeout():
	collision_layer = 10
	%JumpBox. monitoring = true
