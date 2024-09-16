class_name Collectable
extends Area2D

@export_enum("score", "health") var type

@export var value : int

@export var pickup_sound : AudioStreamPlayer2D


func _on_body_entered(body):
	pickup_sound.play()
	set_deferred("monitoring", false)
	$Polygon2D.set_deferred("visible", false)
	match type:
		0:
			SignalBus.emit_signal("update_score", value)
		1:
			SignalBus.emit_signal("update_health", body, value)


func _on_audio_stream_player_2d_finished():
	queue_free()
