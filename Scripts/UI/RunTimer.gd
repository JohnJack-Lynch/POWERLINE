extends Node

var time : float = 0
var min : int = 0
var sec : int = 0
var m_sec : int = 0

var init_score : int = 50000
var second_drop : int = 100
var time_bonus : int

func _ready():
	time_bonus = init_score

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	m_sec = fmod(time, 1) * 100
	sec = fmod(time, 60)
	min = fmod(time, 3600) / 60
	$Panel/Minutes.text = "%02d :" % min
	$Panel/Seconds.text = "%02d ." % sec
	$Panel/Milliseconds.text = "%03d" % m_sec
	
	if min > 0:
		if m_sec == 0:
			time_bonus -= second_drop

func stop():
	set_process(false)

func get_time_formatted():
	return "%02d:%02d.%03d" % [min, sec, m_sec]

func get_time_bonus():
	return time_bonus
