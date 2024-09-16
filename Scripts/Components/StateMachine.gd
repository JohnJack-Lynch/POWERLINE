class_name StateMachine
extends Node

@export var char : CharacterBody2D
@export var cur_state : State

var states : Array[State]

func _ready():
	for child in get_children():
		if child is State:
			states.append(child)
			
			child.char = char
			
			child.connect("interrupt_state", _on_interrupt_state)
		else:
			push_warning("Child " + child.name + " is not a State for StateMachine")

func _physics_process(delta):
	if cur_state.next_state != null:
		switch_states(cur_state.next_state)
	
	cur_state.state_process(delta)

func check_if_can_move():
	return cur_state.can_move

func switch_states(new_state : State):
	if cur_state != null:
		cur_state.on_exit()
		cur_state.next_state = null
	
	cur_state = new_state
	
	cur_state.on_enter()

func _on_interrupt_state(new_state : State):
	switch_states(new_state)

func _unhandled_input(event : InputEvent):
	cur_state.state_input(event)
