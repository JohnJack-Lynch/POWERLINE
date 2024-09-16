extends Control

@onready var stage1_button := $Stage1

@onready var back_button := $Back

@onready var main_menu := $"../VBoxContainer"

@onready var nav_tick := $"../UISounds/NavTick"

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	get_viewport().connect("gui_focus_changed", _on_focus_changed)


func _on_back_pressed():
	visible = false
	main_menu.visible = true

func _on_stage_1_pressed():
	SceneChanger.switch_scene("res://Levels/pt_stage_1.tscn")

func _on_stage_2_pressed():
	SceneChanger.switch_scene("res://Levels/pt_stage_2.tscn")

func _on_stage_3_pressed():
	SceneChanger.switch_scene("res://Levels/pt_stage_3.tscn")

func _on_demo_stage_pressed():
	SceneChanger.switch_scene("res://Levels/demo_stage.tscn")

func _on_focus_changed(control:Control) -> void:
	if control != null:
		nav_tick.play()
