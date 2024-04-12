extends HBoxContainer

@onready var stage1_button := $Stage1

@onready var test_stage_button := $TestStage

@onready var back_button := $Back

@onready var main_menu := $"../VBoxContainer"

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


func _on_back_pressed():
	visible = false
	main_menu.visible = true

func _on_stage_1_pressed():
	SceneChanger.switch_scene("res://Levels/pt_stage_1.tscn")

func _on_stage_2_pressed():
	SceneChanger.switch_scene("res://Levels/pt_stage_2.tscn")

func _on_stage_3_pressed():
	SceneChanger.switch_scene("res://Levels/pt_stage_3.tscn")

func _on_test_stage_pressed():
	SceneChanger.switch_scene("res://Levels/test_world_node.tscn")



