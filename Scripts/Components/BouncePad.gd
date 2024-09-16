@tool
class_name BouncePad
extends Area2D

@export var spring_force : int :
	set(dir):
		spring_force = dir
		$Indicator.target_position.y = -spring_force / 3.1

@export var angle : Vector2 : 
	set(rot):
		angle = rot
		rotation_degrees = angle.x

@export var texture : Texture2D :
	set(spr):
		$Sprite2D.texture = spr

@export var sound : AudioStream :
	set(snd):
		$AudioStreamPlayer2D.stream = snd

@export var retain_momentum : bool = false

func _on_body_entered(body):
	if body is Player:
		if !retain_momentum:
			body.velocity.x = spring_force * angle.normalized().x
		#print(spring_force * angle.normalized().x)
		body.velocity.y = -spring_force * angle.normalized().y
		#print(-spring_force * angle.normalized().y)
