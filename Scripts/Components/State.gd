class_name State
extends Node

@export var can_move := true

var char : CharacterBody2D

var next_state : State

signal interrupt_state(new_state : State)

func state_process(delta):
	pass

func state_input(event : InputEvent):
	pass

func on_enter():
	pass

func on_exit():
	pass
