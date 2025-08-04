extends EntitySkin

const AIR_ROTATION_SPEED: float = 3.2
const GROUND_ROTATION_SPEED: float = 13.0

func set_running_animation_state(speed: float) -> void:
	var state: int = animation_states.walking
	
	if speed > 355 and speed <= 595:
		state = animation_states.running
	elif speed > 595:
		state = animation_states.peel_out
	
	set_animation_state(state)

func set_regular_animation_speed(value: float) -> void:
	var speed: float = max(8.0 / 60.0 + value / 120.0, 1.0)
	set_animation_speed(speed)

func set_rolling_animation_speed(value: float) -> void:
	var speed: float = max(4 / 60.0 + value / 120.0, 1.0)
	set_animation_speed(speed)
