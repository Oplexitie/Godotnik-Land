extends Node2D

@export var move_height: float = 50
@export var move_time: float = 0.5

var destination: Vector2 = Vector2.UP * move_height 
var move_tween: Tween

@onready var visible_timer: Timer = $Timer

func start_movement() -> void:
	if move_tween: move_tween.kill()
	move_tween = create_tween()
	move_tween.tween_property(self, "position", destination, move_time)
	
	visible_timer.start()

func _on_timer_timeout() -> void:
	visible = false
	queue_free()
