class_name KeyRebindButton
extends Control

@onready var label := $HBoxContainer/Label
@onready var button := $HBoxContainer/Button

@export var action_name : String = "PL_LEFT"

func _ready():
	set_process_unhandled_key_input(false)
	set_action_name()
	set_key_text()
	load_keybinds()

func _unhandled_key_input(event):
	button.button_pressed = false
	rebind_key(event)

func load_keybinds():
	rebind_key(SettingsData.get_keybind(action_name))

func set_action_name():
	label.text = "Unassigned"
	
	match action_name:
		"PL_LEFT":
			label.text = "Left"
		"PL_RIGHT":
			label.text = "Right"
		"PL_DOWN":
			label.text = "Down"
		"PL_UP":
			label.text = "Up"
		"PL_JUMP":
			label.text = "Jump"
		"PL_SHOOT":
			label.text = "Shoot"
		"PL_ATTACK":
			label.text = "Attack"

func set_key_text():
	var action_events = InputMap.action_get_events(action_name)
	var action_event = action_events[0]
	var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
	
	button.text = "%s" % action_keycode
	

func rebind_key(event):
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)
	SettingsData.set_keybind(action_name, event)
	
	set_process_unhandled_key_input(false)
	set_key_text()
	set_action_name()

func _on_button_toggled(toggled_on):
	if toggled_on:
		button.text = "Enter new input"
		set_process_unhandled_key_input(toggled_on)
		
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = false
				i.set_process_unhandled_key_input(false)
		
	else:
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = true
				i.set_process_unhandled_key_input(false)
		
		set_key_text()
		
