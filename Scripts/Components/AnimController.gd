class_name AnimController
extends Node

var change_animation = true

var cur_animation = ""
var last_animation = ""

#@export var parent : CharacterBody2D

@export var animation_player : AnimationPlayer
@export var sprite : Sprite2D
