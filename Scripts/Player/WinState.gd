class_name WinState
extends State

func on_enter():
	player.animController.animation_player.play("Emote1")
	player.animController.animation_player.queue("Emote1Loop")
