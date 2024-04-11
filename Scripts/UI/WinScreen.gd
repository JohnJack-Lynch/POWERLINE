extends Control

@export var win_zone : Area2D

@onready var retry_button := $Panel/VBoxContainer/Retry
@onready var menu_button := $Panel/VBoxContainer/Menu

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	
	retry_button.grab_focus()
	win_zone.connect("level_clear", _on_level_clear)

func _on_level_clear(time : String):
	var times = TrackRecords.get_best_times()
	$Panel/Time.text = "Time: " + time
	
	set_records(times)

func set_records(times):
	$Panel/BestTimesList/First.text = "1. " + times[0]
	
	if times.size() == 2:
		$Panel/BestTimesList/Second.text = "2. " + times[1]
	elif times.size() > 2:
		$Panel/BestTimesList/Second.text = "2. " + times[1]
		$Panel/BestTimesList/Third.text = "3. " + times[2]

func _on_menu_pressed():
	SceneChanger.switch_scene("res://main_menu.tscn")

func _on_retry_pressed():
	SceneChanger.switch_scene(get_parent().get_parent().scene_file_path)
