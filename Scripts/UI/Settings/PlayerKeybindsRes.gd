class_name PlayerKeybindsRes
extends Resource

const MOVE_LEFT : String = "PL_LEFT"
const MOVE_RIGHT : String = "PL_RIGHT"
const MOVE_DOWN : String = "PL_DOWN"
const MOVE_UP : String = "PL_UP"
const JUMP : String = "PL_JUMP"
const SHOOT : String = "PL_SHOOT"
const ATTACK : String = "PL_ATTACK"

@export var DEFAULT_MOVE_LEFT_INPUT = InputEventKey.new()
@export var DEFAULT_MOVE_RIGHT_INPUT = InputEventKey.new()
@export var DEFAULT_MOVE_DOWN_INPUT = InputEventKey.new()
@export var DEFAULT_MOVE_UP_INPUT = InputEventKey.new()
@export var DEFAULT_JUMP_INPUT = InputEventKey.new()
@export var DEFAULT_SHOOT_INPUT = InputEventKey.new()
@export var DEFAULT_ATTACK_INPUT = InputEventKey.new()

var move_left_input = InputEventKey.new()
var move_right_input = InputEventKey.new()
var move_down_input = InputEventKey.new()
var move_up_input = InputEventKey.new()
var jump_input = InputEventKey.new()
var shoot_input = InputEventKey.new()
var attack_input = InputEventKey.new()
