class_name ScoreCounter
extends Control

var score : int = 0

@onready var points := $Panel/Points

func _ready():
	SignalBus.connect("update_score", _on_update_score)

func _process(delta):
	points.text = str(score)

func _on_update_score(value : int):
	score += value
	
	if score > 99999999:
		score = 99999999
