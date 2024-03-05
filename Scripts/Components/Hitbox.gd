class_name Hitbox
extends Area2D

@export var damage : float
@export var knockback : Vector2

@export var char : CharacterBody2D

@onready var hitbox_shape := $CollisionShape2D

func _ready():
	#monitoring = false
	char.connect("update_direction", _on_update_direction)

func _on_body_entered(body):
	for child in body.get_children():
		if child is Health:
			child.hit(damage, knockback)
	
	print(body)

func _on_update_direction(facing_right : bool):
	if facing_right:
		scale.x = -1
	else:
		scale.x = 1
