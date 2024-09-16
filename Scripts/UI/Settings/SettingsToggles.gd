class_name SettingsToggles
extends Control

@onready var reticle_toggle := $ReticleToggle
@onready var arrow_toggle := $ArrowToggle

func _ready():
	load_data()

func load_data():
	reticle_toggle.set_pressed_no_signal(SettingsData.get_reticle_toggle())
	arrow_toggle.set_pressed_no_signal(SettingsData.get_arrow_toggle())

func _on_reticle_toggle_toggled(toggled_on):
	SettingsSignalBus.emit_signal("_reticle_enabled", toggled_on)
	
	if toggled_on:
		print("reticle on")
	else:
		print("reticle off")

func _on_arrow_toggle_toggled(toggled_on):
	SettingsSignalBus.emit_signal("_arrow_enabled", toggled_on)
	
	if toggled_on:
		print("arrow on")
	else:
		print("arrow off")
