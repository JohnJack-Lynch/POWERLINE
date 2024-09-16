class_name Health
extends Node

@export var health : float:
	get:
		return health
	set(value):
		SignalBus.emit_signal("update_health", get_parent(), value)
		health = value

@export var char : CharacterBody2D

var max_health : int

signal on_hit()

func _ready():
	max_health = health

func hit(damage : float, knockback : Vector2, impact_dir : Vector2):
	health -= damage
	char.velocity = knockback * impact_dir
	char.kb_dir = impact_dir
	emit_signal("on_hit")

func is_dead():
	if health <= 0:
		return true
