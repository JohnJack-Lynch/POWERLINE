class_name PlayerCamera
extends Camera2D

@export var cam_offset : float = 70.0

@onready var player := get_parent()

var tween

# Called when the node enters the scene tree for the first time.
func _ready():
	offset.y = -30

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if tween:
		tween.kill()
	
	if abs(player.velocity.x) > 550 or player.on_rail:
		tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		tween.tween_property(self, "offset", Vector2((cam_offset * player.direction.x), offset.y), 0.45)
		
		#offset.x = move_toward(offset.x, (cam_offset * player.direction.x), 75 * delta)
	else:
		tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		tween.tween_property(self, "offset", Vector2(0, offset.y), 0.2)
		#offset.x = move_toward(offset.x, 0, 200 * delta)
	
	
