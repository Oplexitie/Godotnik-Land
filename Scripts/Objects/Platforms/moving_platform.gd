extends StaticBody2D
class_name MovingPlatform

@export var amplitude: float = 50
@export var period: float = 1

var time: float

@onready var center: Vector2 = position

func _physics_process(delta) -> void:
	time += delta
	position = Vector2(center.x + amplitude * cos(period * time),center.y + amplitude * sin(period * time)).round()
