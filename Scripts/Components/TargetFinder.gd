class_name TargetFinder
extends Area2D

# based on GDQuest's "Hook" prototype

@export var aim_raycast : RayCast2D
@export var obst_raycast : RayCast2D

@onready var bounds := $CollisionShape2D

var target : set = set_target

var default_pos = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	default_pos = Vector2(bounds.shape.radius, 0)
	aim_raycast.target_position = default_pos
	obst_raycast.target_position = default_pos

func _physics_process(delta):
	self.target = find_best_target()
	
	if target == null:
		aim_raycast.target_position = default_pos

func find_best_target():
	var possible_targets := get_overlapping_bodies()
	var closest_target = null
	
	var dist_to_closest = bounds.shape.radius
	
	for t in possible_targets:
		if t.name == "TileMap":
			continue
		
		var dir_to_target = (t.global_position - global_position).normalized()
		
		aim_raycast.target_position = dir_to_target * bounds.shape.radius
		aim_raycast.global_position = global_position
		
		obst_raycast.target_position = t.global_position - global_position
		obst_raycast.global_position = global_position
		
		if obst_raycast.is_colliding():
			continue
		
		if t != aim_raycast.get_collider() and aim_raycast.is_colliding():
			continue
		
		var distance := global_position.distance_to(t.global_position)
		
		if distance < dist_to_closest:
			dist_to_closest = distance
			closest_target = t
	
	return closest_target

func is_targeting():
	return target != null

func get_target_pos():
	if target:
		return target.global_position

func set_target(value):
	target = value
