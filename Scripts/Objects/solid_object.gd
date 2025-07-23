extends StaticBody2D
class_name SolidObject

# warning-ignore:unused_signal
signal player_right_wall_collision(player)

# warning-ignore:unused_signal
signal player_left_wall_collision(player)

# warning-ignore:unused_signal
signal player_ceiling_collision(player)

# warning-ignore:unused_signal
signal player_ground_collision(player)

@onready var shape: CollisionShape2D = $CollisionShape2D

func is_enabled() -> bool:
	return not shape.disabled

func set_enabled(value: bool) -> void:
	shape.disabled = not value
	queue_free()
