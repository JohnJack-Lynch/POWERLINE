class_name LevelData
extends Node

@export var stage_name : String
@export var respawn_pos : Vector2

@export_category("Rank Reqs")
@export var s_score : int
@export var a_score : int
@export var b_score : int
@export var c_score : int

@export_group("Object References")
@export var player : Player
@export var timer : Control
@export var score_counter : Control
@export var win_zone : WinZone

@export_group("Extras")
@export var move_at_start : bool = false
@export var enter_velocity : Vector2

func _ready():
	if move_at_start:
		player.velocity = enter_velocity

func get_rank(score : int):
	if score > s_score:
		return "S"
	elif score > a_score:
		return "A"
	elif score > b_score:
		return "B"
	elif score > c_score:
		return "C"
	else:
		return "F"
