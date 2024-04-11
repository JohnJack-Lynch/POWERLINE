extends VBoxContainer

@onready var level_select_button := $LevelSelect
@onready var options_button := $Options
@onready var quit_button := $Quit

@onready var level_select_menu := %LevelSelect
@onready var options_menu := %OptionsMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	level_select_button.grab_focus()
	visible = true


func _on_quit_pressed():
	TrackRecords.write_to_file()
	get_tree().quit()


func _on_level_select_pressed():
	$"../LevelSelect/Stage1".grab_focus()
	visible = false
	level_select_menu.visible = true


func _on_options_pressed():
	visible = false
	$"../PlSplash".visible = false
	options_menu.visible = true
