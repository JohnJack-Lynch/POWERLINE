class_name GrappleBeam
extends Node2D

var grapple_pos := Vector2()
var is_grappling = false

var grapple_dir := Vector2()

var beam_length
var cur_length

var beam_out = false

@export var grapple_speed : int

@export var player : Player
@export var target_finder : TargetFinder

@onready var beam := $Line2D

func _ready():
	beam_length = target_finder.bounds.shape.radius
	cur_length = beam_length

#func _process(delta):
#	var tween = get_tree().create_tween()
#	
#	if beam_out:
#		beam.visible = true
#		beam.points[1] = $Node2D.position
#		await tween.tween_property($Node2D, "position", to_local(grapple_pos), 0.05)
#	
#	if is_grappling:
#		beam.points[1] = to_local(grapple_pos)
#	elif !is_grappling and !beam_out:
#		beam.visible = false
#		$Node2D.position = to_local(player.global_position)
#		beam.points[1] = to_local(player.global_position)

func _physics_process(delta):
	if target_finder.target == null:
		if is_grappling or beam_out:
			target_finder.aim_raycast.target_position = to_local(grapple_pos)
		else:
			if Input.is_action_pressed("PL_UP"):
				target_finder.default_pos = Vector2(beam_length * player.dir_facing * 0.71, beam_length * -0.71)
			else:
				target_finder.default_pos = Vector2(beam_length * player.dir_facing, 0)
	
	grapple_dir = target_finder.aim_raycast.target_position.normalized()
	
	grapple_pos = get_grapple_pos()
	
	if grapple_pos:
		cur_length = global_position.distance_to(grapple_pos)
	
	if is_grappling or beam_out:
		target_finder.aim_raycast.enabled = false
		target_finder.aim_raycast.target_position = to_local(grapple_pos)
	else:
		target_finder.aim_raycast.enabled = true
	
	if beam_out:
		var tween = get_tree().create_tween()
		
		beam.visible = true
		beam.points[1] = $Node2D.position
		await tween.tween_property($Node2D, "position", to_local(grapple_pos), 0.05)
		
	
	if is_grappling:
		beam.points[1] = to_local(grapple_pos)
	elif !is_grappling and !beam_out:
		beam.visible = false
		$Node2D.position = to_local(player.global_position)
		beam.points[1] = to_local(player.global_position)

func get_grapple_pos():
	if target_finder.aim_raycast.is_colliding() or target_finder.target != null:
		return target_finder.aim_raycast.get_collision_point()
	else: 
		#return to_local(Vector2.ZERO)
		return grapple_pos
		

func swing(delta):
	var radius = player.global_position - grapple_pos 
	
	if player.velocity.length() < 0.01 or radius.length() < 10:
		is_grappling = false
	
	var angle = 0.0
	var rad_vel = 0.0
	
	if player.velocity.x != 0:
		angle = acos(radius.dot(player.velocity) / (radius.length() * player.velocity.length()))
		rad_vel = cos(angle) * player.velocity.length()
	
	player.velocity += radius.normalized() * -rad_vel# * delta
	
	if player.global_position.distance_to(grapple_pos) > cur_length:
		player.global_position = grapple_pos + radius.normalized() * cur_length
