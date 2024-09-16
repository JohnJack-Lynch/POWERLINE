class_name AttackState
extends State

@export_group("States")
@export var return_state : State

@export_group("")
@export var cooldown_timer : Timer

@onready var hitbox := %Hitbox

func on_enter():
	pass
	#hitbox.hitbox_shape.disabled = false

func on_exit():
	#hitbox.hitbox_shape.disabled = true
	char.can_attack = false
	cooldown_timer.start()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Attack":
		next_state = return_state


func _on_cool_down_timer_timeout():
	pass # Replace with function body.
