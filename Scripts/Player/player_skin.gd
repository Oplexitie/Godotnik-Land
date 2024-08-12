extends Sprite2D
class_name PlayerSkin

const AIR_ROTATION_SPEED: float = 3.2
const GROUND_ROTATION_SPEED: float = 13.0
const ANIMATION_STATES: Dictionary = {
	"idle": 0,
	"walking": 1,
	"running": 2,
	"peel_out": 3,
	"rolling": 4,
	"skidding": 5,
	"corkscrew": 6,
	"balance_front": 7,
	"balance_back": 8,
	"push": 9
}

@onready var animation_tree: AnimationTree = $AnimationTree

var current_state: int

func handle_flip(direction: float) -> void:
	if direction != 0:
		flip_h = direction < 0

func set_animation_state(state: int) -> void:
	if state != current_state:
		current_state = state
		animation_tree.set("parameters/state/transition_request", current_state)

func set_running_animation_state(speed: float) -> void:
	var state: int = ANIMATION_STATES.walking
	
	if speed > 355 and speed <= 595:
		state = ANIMATION_STATES.running
	elif speed > 595:
		state = ANIMATION_STATES.peel_out
	
	set_animation_state(state)

func set_animation_speed(value: float) -> void:
	animation_tree.set("parameters/speed/scale", value)

func set_regular_animation_speed(value: float) -> void:
	var speed: float = max(8.0 / 60.0 + value / 120.0, 1.0)
	set_animation_speed(speed)

func set_rolling_animation_speed(value: float) -> void:
	var speed: float = max(4 / 60.0 + value / 120.0, 1.0)
	set_animation_speed(speed)
