class_name AttackState
extends State

@export_group("States")
@export var ground_state : State
@export var air_state : State

@export_group("")
@export var attack_anims : Array

var cur_frame : float = 0

var cancel_frame
var cur_atk = 0

func on_enter():
	cur_frame = 0.0
	cur_atk = 0

func state_process(delta):
	cur_frame += 1
	
	#print(cur_frame)
	
	if !player.is_on_floor():
		next_state = air_state
	
	gatling_attack(cur_atk)
	
	match cur_atk:
			0:
				player.hitbox.set_properties(5, 90, 200, 25, 1, 0)
			1:
				player.hitbox.set_properties(10, 90, 200, 25, 1, 0)
			2:
				player.hitbox.set_properties(15, 90, 200, 25, 1, 0)

func state_input(event):
	#print(cur_atk)
	#print(cur_atk)
	#var combo_attack = [attack1(), attack2(), attack3()]
	
	if Input.is_action_just_pressed("PL_ATTACK") and player.animController.sprite.frame >= cancel_frame:
		# damage, angle, knockback, hitstun, hitstop, angle_flip
		
		cur_atk += 1
		#if player.animController.cur_animation != attack_anims[cur_atk]:
		#	cur_atk += 1
	
	if cur_atk < 3:
		player.animController.animation_player.play(attack_anims[cur_atk])
		

func attack_action(atk):
	match atk:
		0:
			pass
		1:
			player.velocity.x = (100 * player.dir_facing)
		2:
			player.velocity.x = (300 * player.dir_facing)

func gatling_attack(cur_atk):
	match cur_atk:
		0:
			cancel_frame = 46
		1:
			cancel_frame = 62
		2:
			pass


# radius, height, rot, damage, angle, knockback, active_frames, angle_flip, points, hitstop_dur

#func attack1():
#	if cur_frame >= 4:
#		#print("hitbox spawned")
#		player.create_hitbox(5, 28, deg_to_rad(90), 5, 15, 300, 12, 0, Vector2(19, -3), 1)
#
#func attack2():
#	cur_frame = 0
#
#	if cur_frame >= 8:
#		player.create_hitbox(7.61, 28, deg_to_rad(68.2), 5, 15, 300, 4, 0, Vector2(19, -3), 1)
#	if cur_frame >= 12:
#		player.create_hitbox(7.76, 19.79, deg_to_rad(46.4), 5, 15, 300, 8, 0, Vector2(17, 5), 1)
#
#func attack3():
#	#cur_frame = 0
#
#	pass

func on_exit():
	pass

func _on_animation_player_animation_finished(anim_name):
	next_state = ground_state
