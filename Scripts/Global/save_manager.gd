extends Node

#const RECORDS_FILE_PATH = "user://timerecords.json"
const SETTINGS_FILE_PATH = "user://settings.set"

var settings_dict : Dictionary = {}

func _ready():
	SettingsSignalBus._set_settings_dict.connect(_on_settings_save)
	load_settings()

func _on_settings_save(dat : Dictionary):
	var file = FileAccess.open(SETTINGS_FILE_PATH, FileAccess.WRITE)
	var jstr = JSON.stringify(dat)
	
	file.store_line(jstr)

func load_settings():
	var file = FileAccess.open(SETTINGS_FILE_PATH, FileAccess.READ)
	
	if not file:
		return
	if file == null:
		return
	
	var load_data : Dictionary = {}
	
	while file.get_position() < file.get_length():
		var jstr = file.get_line()
		var j = JSON.new()
		
		var parsed_result = j.parse(jstr)
		
		load_data = j.get_data()
	
	SettingsSignalBus.emit_signal("_load_settings", load_data)
