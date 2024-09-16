extends Control

const FILE_PATH = "user://timerecords.rec"

var stage_dict = {
	"PTStage1" : [],
	"PTStage2" : [],
	"PTStage3" : [],
	"PTStageMedly" : [],
	"DemoStage" : []
}

# Called when the node enters the scene tree for the first time.
func _ready():
	load_times()

func add_time(time : String):
	var temp = []
	
	for s in stage_dict:
		if s == get_tree().current_scene.name:
			temp = stage_dict[s]
			
			temp.append(time)
			temp.sort()
			
			stage_dict[s] = temp
	

func get_best_times():
	var cur_level = get_tree().current_scene.name
	return stage_dict[cur_level]

func get_stage_dict():
	return stage_dict

func write_to_file():
	var file = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	var jstr = JSON.stringify(stage_dict)
	
	file.store_line(jstr)

func load_times():
	var file = FileAccess.open(FILE_PATH, FileAccess.READ)
	
	if not file:
		return
	if file == null:
		return
	
	if FileAccess.file_exists(FILE_PATH) == true:
		if not file.eof_reached():
			var cur_line = JSON.parse_string(file.get_line())
			if cur_line:
				stage_dict["PTStage1"] = cur_line["PTStage1"]
				stage_dict["PTStage2"] = cur_line["PTStage2"]
				stage_dict["PTStage3"] = cur_line["PTStage3"]
				stage_dict["PTStageMedly"] = cur_line["PTStageMedly"]
				stage_dict["DemoStage"] = cur_line["DemoStage"]
