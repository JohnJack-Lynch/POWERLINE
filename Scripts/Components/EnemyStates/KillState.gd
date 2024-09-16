class_name KillState
extends State

@onready var kill_timer = $KillTimer

func on_enter():
	char.collision_layer = 0
	
	SignalBus.emit_signal("update_score", char.kill_points)
	kill_timer.start()

func state_process(delta):
	if char.is_on_floor():
		get_parent().get_parent().queue_free()

func _on_kill_timer_timeout():
	get_parent().get_parent().queue_free()
