class_name Rail
extends Path2D

# code provided by the Sonic Flow Engine Project by Coderman64

@onready var line := $Line2D
@onready var collider := $Area2D/CollisionPolygon2D
@onready var path_follow = $PathFollow2D
@onready var remote_transform := $PathFollow2D/RemoteTransform2D
@onready var marker_2d := $Marker2D
@onready var area_2d := $Area2D
@onready var reset_timer := $ResetTimer

@export var texture : CompressedTexture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#print(position)
	line.points = curve.get_baked_points()
	
	if texture:
		line.texture = texture
	
	var rev_curve : PackedVector2Array = curve.get_baked_points()
	rev_curve.reverse()
	
	for i in range(rev_curve.size()):
		rev_curve.set(i, Vector2(rev_curve[i].x, rev_curve[i].y+1))
	
	var full_curve = curve.get_baked_points()
	full_curve.append_array(rev_curve)
	
	collider.polygon = full_curve

func _on_area_2d_body_entered(body):
	if body is Player and abs(body.velocity.x) >= 150 and body.velocity.y >= 0:
		path_follow.progress = curve.get_closest_offset(body.global_position - self.global_position)
		body.on_rail = true
		body.cur_path = self
		body.cur_rail = path_follow
		remote_transform.set_remote_node(body.get_path())
		print("player on rail")
		

func _on_area_2d_body_exited(body):
	if body is Player and body.on_rail == true:
		reset_timer.start()
		body.on_rail = false
		body.rotation = 0
		remote_transform.set_remote_node(marker_2d.get_path())
		area_2d.set_deferred("monitoring", false)
		#area_2d.collision_mask = 0
		print("player off rail")

func _on_reset_timer_timeout():
	print("done!")
	area_2d.set_deferred("monitoring", true)
