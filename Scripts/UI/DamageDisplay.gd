extends Control

@export var health_text : PackedScene
@export var dam_color : Color
@export var heal_color : Color


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("on_health_changed", on_signal_health_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_signal_health_changed(node : Node, amount : int):
	var label_inst : Label = health_text.instantiate()
	node.add_child(label_inst)
	label_inst.text = str(abs(amount))
	
	if amount >= 0:
		label_inst.modulate = heal_color
	else:
		label_inst.modulate = dam_color
