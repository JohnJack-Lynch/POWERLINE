class_name StunState
extends State

@export var return_state : State

func _ready():
	SignalBus.connect("beam_connect", _on_beam_connect)
	SignalBus.connect("beam_release", _on_beam_release)

func on_enter():
	char.set_physics_process(false)

func on_exit():
	char.set_physics_process(true)

func _on_beam_connect(target : Node):
	if target == char:
		emit_signal("interrupt_state", self)

func _on_beam_release():
	next_state = return_state
