class_name LockOnState
extends State

@export_group("States")
@export var patrol_state : State

func on_enter():
	player.direction.x = 0

func state_process(delta):
	
	
	player.direction = player.target_finder.aim_raycast.target_position.normalized()
	
	if !player.target_finder.target:
		next_state = patrol_state
	
#	if abs(player.global_position.distance_to(player.target_finder.get_target_pos())) <= 35:
#		player.direction.x = 0
#		player.animController.animation_player.play("Attack")
	
	#player.direction.x = 0
	#player.animController.animation_player.play("Attack")

func on_exit():
	player.direction = Vector2.ZERO
