extends Control

@onready var option_button := $OptionButton

const RESOLUTION_DICT : Dictionary = {
	"1920 x 1080" : Vector2i(1920, 1080),
	"1280 x 720" : Vector2i(1280, 720),
	"1152 x 648" : Vector2i(1152, 648),
}

func _ready():
	add_resolution_items()
	option_button.item_selected.connect(_on_resolution_selected)
	load_data()

func load_data():
	_on_resolution_selected(SettingsData.get_res_idx())
	option_button.select(SettingsData.get_res_idx())

func add_resolution_items():
	for r in RESOLUTION_DICT:
		option_button.add_item(r)

func _on_resolution_selected(index : int):
	SettingsSignalBus.emit_signal("_resolution_selected", index)
	DisplayServer.window_set_size(RESOLUTION_DICT.values()[index])
