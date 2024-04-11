class_name PlayerAnimController
extends AnimController

@export var player : Player

func _ready():
	animation_player.set_speed_scale(1)
	sprite.rotation = 0

func _process(delta):
	var direction = Vector2()
	
	direction.x = Input.get_axis("PL_LEFT", "PL_RIGHT")
	
	if direction.x == 0 and player.velocity.x == 0:
		if player.state_machine.cur_state.name == "Crouch":
			cur_animation = "CrouchLoop"
		else:
			cur_animation = "Idle"
	else:
		if player.state_machine.cur_state.name != "WallSlide":
			if direction.x == 0:
				sprite.flip_h = player.velocity.x > 0
			else:
				if player.state_machine.check_if_can_move(): 
					sprite.flip_h = direction.x > 0
		
		if player.state_machine.cur_state.name == "Slide":
			cur_animation = "Slide"
		elif player.state_machine.cur_state.name == "Ground":
			cur_animation = "Jog"
	
	if !player.is_on_floor():
		if player.velocity.y < 0:# and Input.is_action_just_pressed("PL_JUMP"):
			cur_animation = "JumpUp"
		else:
			cur_animation = "JumpTR"
			animation_player.queue("Fall")
	
	if player.is_on_slope() and (cur_animation == "Jog" or cur_animation == "Slide") and player.get_floor_angle() > 0.46:
		var tween = get_tree().create_tween()
		tween.tween_property(sprite, "rotation", player.get_floor_normal().x, 0.05)
		#sprite.rotation = player.get_floor_normal().x
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(sprite, "rotation", 0, 0.05)
		#sprite.rotation = 0
	
	change_anim_speed("Jog")
	
	if last_animation != cur_animation:
		animation_player.play(cur_animation)
		last_animation = cur_animation
	
	if animation_player.current_animation != cur_animation:
		cur_animation = animation_player.current_animation

func _physics_process(delta):
	if sprite.flip_h:
		player.dir_facing = 1
	else:
		player.dir_facing = -1

func change_anim_speed(anim_to_affect : String):
	if cur_animation == anim_to_affect:
		var time_scale = abs(player.velocity.x / player.base_speed)
		
		
		if time_scale > 3.0:
			time_scale = 3.0
		elif time_scale < 0.5:
			time_scale = 0.5
		
		animation_player.set_speed_scale(time_scale)
	else:
		animation_player.set_speed_scale(1)
