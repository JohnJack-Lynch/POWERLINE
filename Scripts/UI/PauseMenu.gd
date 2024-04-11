extends Control

var is_paused : bool = false:
	set = set_paused

func _ready():
	visible = false

func _unhandled_input(event):
	if event.is_action_pressed("PL_PAUSE"):
		self.is_paused = !is_paused

func set_paused(value : bool):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _on_resume_pressed():
	is_paused = false

func _on_restart_pressed():
	is_paused = false
	SceneChanger.switch_scene(get_parent().get_parent().scene_file_path)

func _on_main_menu_pressed():
	is_paused = false
	SceneChanger.switch_scene("res://main_menu.tscn")
