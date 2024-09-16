class_name PatrolState
extends State

@export var lock_on_state : State

var in_motion = false

func on_enter():
	%Hitbox.set_deferred("monitoring", false)

func state_process(delta):
	if char.target_finder.target:
		next_state = lock_on_state
	
	if !in_motion:
		var new_dir = randf_range(-1.0, 1.0)
		var move_time = randi_range(2, 8)
		
		if abs(new_dir) < 0.3:
			new_dir = 0
		
		$MoveTimer.wait_time = move_time
		
		$MoveTimer.start()
		
		in_motion = true
	
	if in_motion and char.wall_check():
		%LeftWallRaycast.set_deferred("enabled", false)
		%RightWallRaycast.set_deferred("enabled", false)
		char.direction.x = -char.direction.x
		char.velocity.x = -char.velocity.x
	
	if in_motion and char.right_drop_check():
		#%LedgeCastL1.set_deferred("enabled", false)
		#%LedgeCastL2.set_deferred("enabled", false)
		char.direction.x = -char.direction.x
		char.velocity.x = -char.velocity.x
	elif in_motion and char.left_drop_check():
		#%LedgeCastR1.set_deferred("enabled", false)
		#%LedgeCastR2.set_deferred("enabled", false)
		char.direction.x = -char.direction.x
		char.velocity.x = -char.velocity.x
	
	#if in_motion:
		#print($MoveTimer.time_left)
	

func on_exit():
	in_motion = false
	$MoveTimer.stop()
	
	%LeftWallRaycast.set_deferred("enabled", true)
	%RightWallRaycast.set_deferred("enabled", true)
	
	#%LedgeCastL1.set_deferred("enabled", true)
	#%LedgeCastL2.set_deferred("enabled", true)
	#%LedgeCastR1.set_deferred("enabled", true)
	#%LedgeCastR2.set_deferred("enabled", true)
	#
	#if next_state == hit_state:
		#char.direction = Vector2.ZERO
		#char.velocity = Vector2.ZERO


func _on_move_timer_timeout():
	in_motion = false
	
	%LeftWallRaycast.set_deferred("enabled", true)
	%RightWallRaycast.set_deferred("enabled", true)
	
	#%LedgeCastL1.set_deferred("enabled", true)
	#%LedgeCastL2.set_deferred("enabled", true)
	#%LedgeCastR1.set_deferred("enabled", true)
	#%LedgeCastR2.set_deferred("enabled", true)
