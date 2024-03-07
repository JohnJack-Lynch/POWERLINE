class_name Reticle
extends Node2D

const DEFAULT_POINTS_COUNT := 32

@export var color : Color

@export var char : CharacterBody2D
@export var target_finder : TargetFinder

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _draw():
	draw_circle_outline(self, Vector2.ZERO, 6.0, color, 0.5)
	draw_circle(Vector2.ZERO, 3.0, color)

static func draw_circle_outline(obj, position, radius, color, thickness):
	var points_array := PackedVector2Array()
	for i in range(DEFAULT_POINTS_COUNT + 1):
		var angle := 2 * PI * i / DEFAULT_POINTS_COUNT
		var point = position + Vector2(cos(angle) * radius, sin(angle) * radius)
		points_array.append(point)
	obj.draw_polyline(points_array, color, thickness, true)
