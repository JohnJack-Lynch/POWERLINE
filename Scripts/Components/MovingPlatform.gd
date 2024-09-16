class_name MovingPlatform
extends Path2D

@export var closed_path : bool = true
@export var speed : float = 2.0
@export var speed_scale : float = 1.0

@export var texture : Texture2D :
	set(spr):
		$AnimatableBody2D/Sprite2D.texture = spr

@onready var path_follow = $PathFollow2D
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	if !closed_path:
		animation_player.play("Move")
		animation_player.speed_scale = speed_scale
		set_physics_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	path_follow.progress += speed
