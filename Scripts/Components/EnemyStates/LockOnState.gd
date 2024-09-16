class_name LockOnState
extends State

@export_group("States")
@export var patrol_state : State
@export var attack_state : State

func on_enter():
	%Hitbox.set_deferred("monitoring", false)
	char.direction.x = 0

func state_process(delta):
	#print(char.global_position.distance_to(char.target_finder.get_target_pos()))
	
	char.direction = char.target_finder.aim_raycast.target_position.normalized()
	
	if !char.target_finder.target:
		next_state = patrol_state
	
	if char.target_finder.target and abs(char.global_position.distance_to(char.target_finder.get_target_pos())) <= 35 and char.can_attack:
		next_state = attack_state
	
	#player.direction.x = 0
	#player.animController.animation_player.play("Attack")

func on_exit():
	#char.direction = Vector2.ZERO
	pass


func _on_cool_down_timer_timeout():
	char.can_attack = true
