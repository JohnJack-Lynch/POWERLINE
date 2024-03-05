class_name PatrolState
extends State

@export var lock_on_state : State
@export var hit_state : State

var in_motion = false

func on_enter():
	pass

func state_process(delta):
	if player.target_finder.target:
		next_state = lock_on_state
	
	if !in_motion:
		var new_dir = randf_range(-1.0, 1.0)
		var move_time = randi_range(2, 8)
		
		if abs(new_dir) < 0.3:
			new_dir = 0
		
		$MoveTimer.wait_time = move_time
		player.direction.x = new_dir
		
		$MoveTimer.start()
		
		in_motion = true

func on_exit():
	in_motion = false
	$MoveTimer.stop()


func _on_move_timer_timeout():
	in_motion = false
