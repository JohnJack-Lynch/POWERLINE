class_name HitState
extends State

@export_group("States")
@export var return_state : State
@export var death_state : State

@export_group("")
@export var health : Health
@export var invuln_timer : Timer

func on_enter():
	char.collision_layer = 0
	
	if char is Enemy:
		%JumpBox.set_deferred("monitoring", false)
	
	if char is Player:
		char.no_hit = false
	
	char.direction = char.kb_dir

func state_process(delta):
	if char.is_on_floor():
		next_state = return_state

func _on_health_on_hit():
	if health.health > 0:
		emit_signal("interrupt_state", self)
	else:
		emit_signal("interrupt_state", death_state)

func on_exit():
	invuln_timer.start()
	char.velocity.x = 0





func _on_invuln_timer_timeout():
	pass # Replace with function body.
