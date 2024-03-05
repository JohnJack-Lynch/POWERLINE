extends Control

@export var win_zone : Area2D

@onready var retry_button := $Panel/VBoxContainer/Retry
@onready var menu_button := $Panel/VBoxContainer/Menu

# Called when the node enters the scene tree for the first time.
func _ready():
	retry_button.grab_focus()
	win_zone.connect("level_clear", _on_level_clear)


func _on_level_clear(time : String):
	$Panel/Time.text = "Time: " + time

func _on_menu_pressed():
	SceneChanger.switch_scene("res://main_menu.tscn")

func _on_retry_pressed():
	SceneChanger.switch_scene(get_parent().get_parent().scene_file_path)
