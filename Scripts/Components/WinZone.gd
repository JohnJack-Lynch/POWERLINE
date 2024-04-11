class_name WinZone
extends Area2D

@export var player : Player
@export var timer : Control
@export var win_screen : Control

var finish_time : String

signal level_clear(time : String)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_body_entered(body):
	timer.visible = false
	player.set_physics_process(false)
	timer.stop()
	finish_time = timer.get_time_formatted()
	TrackRecords.add_time(finish_time)
	emit_signal("level_clear", finish_time)
	win_screen.visible = true
