extends Node

@onready var default_settings := preload("res://Resources/default_settings.tres")
@onready var keybinds := preload("res://Resources/default_player_keybinds.tres")

var window_mode_idx : int = 0
var res_idx : int = 0
var reticle_toggle := true
var arrow_toggle := true

var load_data : Dictionary = {}

func _ready():
	SettingsSignalBus._window_mode_selected.connect(_on_window_mode_selected)
	SettingsSignalBus._resolution_selected.connect(_on_resolution_selected)
	SettingsSignalBus._reticle_enabled.connect(_on_reticle_enabled)
	SettingsSignalBus._arrow_enabled.connect(_on_arrow_enabled)
	SettingsSignalBus._load_settings.connect(_on_load_settings)
	
	create_dictionary()

func create_dictionary():
	var settings_data_dict : Dictionary = {
		"window_mode_idx" : window_mode_idx,# window settings
		"res_idx" : res_idx,
		"reticle_toggle" : reticle_toggle,# misc settings
		"arrow_toggle" : arrow_toggle,
		"keybinds" : create_keybind_dict()
	}
	
	return settings_data_dict

func create_keybind_dict():
	var keybinds_dict : Dictionary = {
		keybinds.MOVE_LEFT : keybinds.move_left_input,
		keybinds.MOVE_RIGHT : keybinds.move_right_input,
		keybinds.MOVE_DOWN : keybinds.move_down_input,
		keybinds.MOVE_UP : keybinds.move_up_input,
		keybinds.JUMP : keybinds.jump_input,
		keybinds.SHOOT : keybinds.shoot_input,
		keybinds.ATTACK : keybinds.attack_input,
	}
	
	return keybinds_dict

func get_window_mode_idx():
	if load_data == {}:
		return default_settings.DEF_WINDOW_MODE
	return window_mode_idx

func get_res_idx():
	if load_data == {}:
		return default_settings.DEF_RES_IDX
	return res_idx

func get_reticle_toggle():
	if load_data == {}:
		return default_settings.DEF_RETICLE_TOGGLE
	return reticle_toggle

func get_arrow_toggle():
	if load_data == {}:
		return default_settings.DEF_ARROW_TOGGLE
	return arrow_toggle

func get_keybind(action : String):
	if !load_data.has("keybinds"):
		match action:
			keybinds.MOVE_LEFT:
				return keybinds.DEFAULT_MOVE_LEFT_INPUT
			keybinds.MOVE_RIGHT:
				return keybinds.DEFAULT_MOVE_RIGHT_INPUT
			keybinds.MOVE_DOWN:
				return keybinds.DEFAULT_MOVE_DOWN_INPUT
			keybinds.MOVE_UP:
				return keybinds.DEFAULT_MOVE_UP_INPUT
			keybinds.JUMP:
				return keybinds.DEFAULT_JUMP_INPUT
			keybinds.SHOOT:
				return keybinds.DEFAULT_SHOOT_INPUT
			keybinds.ATTACK:
				return keybinds.DEFAULT_ATTACK_INPUT
	else:
		match action:
			keybinds.MOVE_LEFT:
				return keybinds.move_left_input
			keybinds.MOVE_RIGHT:
				return keybinds.move_right_input
			keybinds.MOVE_DOWN:
				return keybinds.move_down_input
			keybinds.MOVE_UP:
				return keybinds.move_up_input
			keybinds.JUMP:
				return keybinds.jump_input
			keybinds.SHOOT:
				return keybinds.shoot_input
			keybinds.ATTACK:
				return keybinds.attack_input

func set_keybind(action : String, event):
	match action:
		keybinds.MOVE_LEFT:
			keybinds.move_left_input = event
		keybinds.MOVE_RIGHT:
			keybinds.move_right_input = event
		keybinds.MOVE_DOWN:
			keybinds.move_down_input = event
		keybinds.MOVE_UP:
			keybinds.move_up_input = event
		keybinds.JUMP:
			keybinds.jump_input = event
		keybinds.SHOOT:
			keybinds.shoot_input = event
		keybinds.ATTACK:
			keybinds.attack_input = event
		

func _on_window_mode_selected(index : int):
	window_mode_idx = index

func _on_resolution_selected(index : int):
	res_idx = index

func _on_reticle_enabled(value : bool):
	reticle_toggle = value

func _on_arrow_enabled(value : bool):
	arrow_toggle = value

func _on_load_keybinds(keys_dict : Dictionary):
	var load_move_left = InputEventKey.new()
	var load_move_right = InputEventKey.new()
	var load_move_down = InputEventKey.new()
	var load_move_up = InputEventKey.new()
	var load_jump = InputEventKey.new()
	var load_shoot = InputEventKey.new()
	var load_attack = InputEventKey.new()
	
	load_move_left.set_physical_keycode(int(keys_dict.PL_LEFT))
	load_move_right.set_physical_keycode(int(keys_dict.PL_RIGHT))
	load_move_down.set_physical_keycode(int(keys_dict.PL_DOWN))
	load_move_up.set_physical_keycode(int(keys_dict.PL_UP))
	load_jump.set_physical_keycode(int(keys_dict.PL_JUMP))
	load_shoot.set_physical_keycode(int(keys_dict.PL_SHOOT))
	load_attack.set_physical_keycode(int(keys_dict.PL_ATTACK))
	
	keybinds.move_left_input = load_move_left
	keybinds.move_right_input = load_move_right
	keybinds.move_down_input = load_move_down
	keybinds.move_up_input = load_move_up
	keybinds.jump_input = load_jump
	keybinds.shoot_input = load_shoot
	keybinds.attack_input = load_attack
	

func _on_load_settings(settings_dict : Dictionary):
	load_data = settings_dict
	
	_on_window_mode_selected(load_data.window_mode_idx)
	_on_resolution_selected(load_data.res_idx)
	_on_reticle_enabled(load_data.reticle_toggle)
	_on_arrow_enabled(load_data.arrow_toggle)
	_on_load_keybinds(load_data.keybinds)
