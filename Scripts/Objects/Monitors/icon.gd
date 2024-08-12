extends Node2D

@export var move_height: float = 50
@export var move_speed: float = 130
@export var visible_time: float = 1

var destination: Vector2 = Vector2.UP * move_height 
var movement: bool
var visible_timer: float

func _process(delta):
	if movement:
		handle_movement(delta)
		handle_visibility(delta)

func handle_movement(delta: float):
	var speed = move_speed * delta
	position = position.move_toward(destination, speed)

func handle_visibility(delta: float):
	if visible_timer <= visible_time:
			visible_timer += delta
	else:
		visible_timer = 0
		visible = false
		queue_free()

func set_movement(value: bool):
	movement = value
