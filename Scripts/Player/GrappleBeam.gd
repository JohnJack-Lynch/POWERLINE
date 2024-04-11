class_name GrappleBeam
extends Node2D

# based on the tutorial by DevWorm

var grapple_pos := Vector2()
var is_grappling = false

var grapple_dir := Vector2()

var beam_length : float
var cur_length : float
var slack : float

var beam_out = false

var beam_tween

@export var grapple_speed : float = 0.05

@export var player : Player
@export var target_finder : TargetFinder

@onready var beam := $Line2D
@onready var assist_arrow := $AimArrow

signal beam_connect

func _ready():
	beam_length = target_finder.bounds.shape.radius
	cur_length = beam_length
	slack = beam_length + 15
	assist_arrow.visible = false

func _process(delta):
	beam.points[1] = $Marker2D.position
	pass

func _physics_process(delta):
	if target_finder.target == null:
		if is_grappling:# or beam_out:
			target_finder.aim_raycast.target_position = to_local(grapple_pos)
		else:
			if Input.is_action_pressed("PL_UP"):
				target_finder.default_pos = Vector2(beam_length * player.dir_facing * 0.71, beam_length * -0.71)
			else:
				target_finder.default_pos = Vector2(beam_length * player.dir_facing, 0)
	
	if target_finder.aim_raycast.is_colliding() and target_finder.target == null and !is_grappling:
		assist_arrow.visible = true
		assist_arrow.position = to_local(target_finder.aim_raycast.get_collision_point())
	else:
		assist_arrow.visible = false
		assist_arrow.position = Vector2.ZERO
	
	
	grapple_dir = target_finder.aim_raycast.target_position.normalized()
	
	if grapple_pos:
		cur_length = global_position.distance_to(grapple_pos)
	
	
	
	if is_grappling:
		$Marker2D.position = to_local(grapple_pos)
		beam.set_point_position(1, to_local(grapple_pos))
	else:
		$Marker2D.position = to_local(player.global_position)
		beam.set_point_position(1, player.global_position)

func _unhandled_input(event):
	if event.is_action_pressed("PL_SHOOT"):
		if get_grapple_pos() != to_local(Vector2.ZERO):
			grapple_pos = get_grapple_pos()
			shoot(to_local(grapple_pos))
		else:
			pass
	
	if event.is_action_released("PL_SHOOT"):
		if beam_tween and beam_tween.is_running():
			beam_tween.kill()
		
		$Marker2D.position = to_local(player.global_position)
		beam.points[1] = to_local(player.global_position)

func get_grapple_pos():
	if target_finder.aim_raycast.is_colliding() or target_finder.target != null:
		return target_finder.aim_raycast.get_collision_point()
	else: 
		return to_local(Vector2.ZERO)
		#return grapple_pos
		

func shoot(pivot_point : Vector2):
	
	if beam_tween:
		beam_tween.kill()
	
	beam_tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	await beam_tween.tween_property($Marker2D, "position", pivot_point, grapple_speed).finished
	
	is_grappling = true

func swing(delta):
	var radius = player.global_position - grapple_pos 
	
	# disables the grapple if the player gets too close
	if player.velocity.length() < 0.01 or radius.length() < 10:
		is_grappling = false
	
	var angle = 0.0
	var rad_vel = 0.0
	
	if player.velocity.x != 0:
		angle = acos(radius.dot(player.velocity) / (radius.length() * player.velocity.length()))
		rad_vel = cos(angle) * player.velocity.length()
	
	player.velocity += (radius.normalized() * -rad_vel)# * delta
	
	if player.global_position.distance_to(grapple_pos) > cur_length:
		player.global_position = grapple_pos + radius.normalized() * cur_length
	
	player.velocity += (grapple_pos - player.global_position).normalized() * 500  * delta
