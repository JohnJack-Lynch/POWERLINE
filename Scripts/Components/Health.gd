class_name Health
extends Node

@export var max_health : float

@export var char : CharacterBody2D

var cur_health := max_health: set = set_cur_health, get = get_cur_health

signal on_hit(node : Node, damage : int)

func hit(damage : float, knockback : Vector2):
	cur_health -= damage
	
	char.velocity = knockback
	
	emit_signal("on_hit", get_parent(), damage)

func is_dead():
	if cur_health <= 0:
		return true

func get_cur_health():
	return cur_health

func set_cur_health(value : float):
	SignalBus.emit_signal("on_health_changed", get_parent(), value - cur_health)
	cur_health = value
