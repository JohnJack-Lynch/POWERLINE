extends Control

@onready var level_select_button := $LevelSelect
@onready var options_button := $Options
@onready var quit_button := $Quit

@onready var level_select_menu := %LevelSelect
@onready var options_menu := %OptionsMenu

@onready var nav_tick := $"../UISounds/NavTick"
@onready var confirm := $"../UISounds/Confirm"

# Called when the node enters the scene tree for the first time.
func _ready():
	level_select_button.grab_focus()
	visible = true
	get_viewport().connect("gui_focus_changed", _on_focus_changed)

func _on_quit_pressed():
	TrackRecords.write_to_file()
	get_tree().quit()

func _on_level_select_pressed():
	confirm.play()
	$"../LevelSelect/Stage1".grab_focus()
	visible = false
	level_select_menu.visible = true

func _on_options_pressed():
	confirm.play()
	visible = false
	$"../PlSplash".visible = false
	options_menu.visible = true

func _on_focus_changed(control:Control) -> void:
	if control != null:
		nav_tick.play()
