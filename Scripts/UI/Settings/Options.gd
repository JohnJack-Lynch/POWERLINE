class_name Options
extends Control

@onready var back := $MarginContainer/Back

@onready var main_menu := $"../VBoxContainer"

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


func _on_back_pressed():
	SettingsSignalBus.emit_signal("_set_settings_dict", SettingsData.create_dictionary())
	visible = false
	main_menu.visible = true
	$"../PlSplash".visible = true
