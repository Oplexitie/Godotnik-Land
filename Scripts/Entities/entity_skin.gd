extends Sprite2D
class_name EntitySkin

@export var animation_states: Dictionary[String,int]

var current_state: int

@onready var animation_tree: AnimationTree = $AnimationTree

func handle_flip(direction: float) -> void:
	if direction != 0:
		flip_h = direction < 0

func set_animation_state(state: int) -> void:
	if state != current_state:
		current_state = state
		animation_tree.set("parameters/state/transition_request", current_state)

func set_animation_speed(value: float) -> void:
	animation_tree.set("parameters/speed/scale", value)
