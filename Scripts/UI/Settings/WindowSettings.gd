extends Control

@onready var option_button := $OptionButton

const WINDOW_MODES : Array[String] = [
	"Fullscreen",
	"Windowed",
	"Windowed Borderless",
	"Fullscreen Borderless"
]

func _ready():
	add_windowmode_items()
	option_button.item_selected.connect(_on_windowed_selected)
	load_data()

func load_data():
	_on_windowed_selected(SettingsData.get_window_mode_idx())
	option_button.select(SettingsData.get_window_mode_idx())

func add_windowmode_items():
	for m in WINDOW_MODES:
		option_button.add_item(m)

func _on_windowed_selected(index : int):
	SettingsSignalBus.emit_signal("_window_mode_selected", index)
	match index:
		0: # fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: # windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: # w-borderless
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3: # f-borderless
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
