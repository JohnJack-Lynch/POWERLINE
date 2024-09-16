class_name EnemyAnimController
extends AnimController

@export var enemy : Enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enemy.direction.x != 0:
		sprite.flip_h = enemy.direction.x > 0
	
	if enemy.state_machine.cur_state.name == "Hit" or enemy.state_machine.cur_state.name == "Kill" or enemy.state_machine.cur_state.name == "Stun":
		cur_animation = "Hit"
	elif enemy.state_machine.cur_state.name == "Attack":
		cur_animation = "Attack"
	else:
		if abs(enemy.velocity.x) > 0:
			cur_animation = "Walk"
		else:
			cur_animation = "Idle"
	
	if last_animation != cur_animation:
		animation_player.play(cur_animation)
		last_animation = cur_animation
	
	if animation_player.current_animation != cur_animation:
		cur_animation = animation_player.current_animation
