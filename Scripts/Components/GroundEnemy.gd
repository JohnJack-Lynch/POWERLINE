class_name GroundEnemy
extends Enemy

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	#print(state_machine.cur_state)
	
	var cur_speed : int
	var facing_dir : int
	
	
	
	if state_machine.cur_state.name == "LockOn":
		cur_speed = follow_speed
	else:
		cur_speed = idle_speed
	
	# Add the gravity.
	if !is_on_floor():
		velocity.y += gravity * delta
	
	if abs(direction.x) > 0 and state_machine.check_if_can_move():
		velocity.x = direction.x * cur_speed
	elif direction.x == 0 or state_machine.cur_state.name == "Attack":
		velocity.x = move_toward(velocity.x, 0, cur_speed)
	
	if !$Sprite2D.flip_h:
		facing_dir = 1
	else:
		facing_dir = -1
	
	target_finder.default_pos = Vector2(target_finder.bounds.shape.radius * facing_dir, 0)
	
	impact_dir = Vector2(-facing_dir, -0.5)
	
	emit_signal("update_direction", !$Sprite2D.flip_h)
	
	move_and_slide()

func wall_check():
	if %LeftWallRaycast.is_colliding() or %RightWallRaycast.is_colliding():
		return true

func left_drop_check():
	if %LedgeCastL1.is_colliding() and %LedgeCastL2.is_colliding():
		return false
	else:
		return true

func right_drop_check():
	if %LedgeCastR1.is_colliding() and %LedgeCastR2.is_colliding():
		return false
	else:
		return true

func _on_jump_box_body_entered(body):
	if body is Player:
		#if body.global_position.y < $JumpBox.global_position.y:
			#print("true")
		if body.velocity.y > 0:
			body.velocity.y = (-body.velocity.y * 1.2)
			health.hit(1, Vector2(0, 500), Vector2.DOWN)

func _on_invuln_timer_timeout():
	collision_layer = 10
	%JumpBox. monitoring = true
