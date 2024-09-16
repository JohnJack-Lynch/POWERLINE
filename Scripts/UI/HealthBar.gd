class_name HealthBar
extends Control

@onready var health_text := $Panel/Health

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("update_health", _on_update_health)

func _on_update_health(node : Node, value : int):
	if node is Player:
		health_text.text = str(value)
