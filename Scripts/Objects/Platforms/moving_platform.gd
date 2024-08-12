extends StaticBody2D
class_name MovingPlatform

@export var amplitude: float = 50
@export var period: float = 1

@onready var center: Vector2 = position

var time: float

func _physics_process(delta):
	time += delta
	position.x = center.x + amplitude * cos(period * time)
	position.y = center.y + amplitude * sin(period * time)
