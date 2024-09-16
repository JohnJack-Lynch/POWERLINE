class_name WinZone
extends Area2D

@export var player : Player
@export var timer : Control
@export var score_counter : Control
@export var win_screen : Control

var finish_time : String

signal level_clear(time : String, score : int)

func _ready():
	pass

func _on_body_entered(body):
	timer.visible = false
	score_counter.visible = false
	player.set_physics_process(false)
	timer.stop()
	if TrackRecords.get_best_times().size() >= 1:
		win_screen.old_record = TrackRecords.get_best_times()[0]
	#print(TrackRecords.get_best_times()[0])
	finish_time = timer.get_time_formatted()
	TrackRecords.add_time(finish_time)
	#print(TrackRecords.get_best_times()[0])
	emit_signal("level_clear", finish_time, (score_counter.score + timer.get_time_bonus() + (player.health.health * 2000)))
	#print(score_counter.score + timer.get_time_bonus() + (player.health.health * 2000))
	win_screen.visible = true
