class_name Reticle
extends Node2D

#var target_finder : TargetFinder

@onready var anim_player := $AnimationPlayer
@onready var audio_stream_player := $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true)
	SignalBus.connect("target_changed", _on_target_changed)
	anim_player.play("LockOn")

func _on_target_changed():
	#print("target changed")
	anim_player.play("LockOn")
	audio_stream_player.play()
	
