extends PlayerState
class_name AirPlayerState

var last_absolute_horizontal_speed: float
var can_use_shield: bool

func enter(player: Player):
	can_use_shield = player.is_rolling
	last_absolute_horizontal_speed = abs(player.velocity.x)
	
	if player.is_rolling:
		player.set_bounds(1)

func step(player: Player, delta: float):
	player.handle_gravity(delta)
	player.handle_acceleration(delta)
	player.handle_deceleration(delta)

	if player.is_grounded():
		if player.input_direction.y < 0 and abs(player.velocity.x) > player.current_stats.min_speed_to_roll:
			player.state_machine.change_state("Rolling")
		else:
			player.state_machine.change_state("Regular")
	elif Input.is_action_just_pressed("player_a") and can_use_shield:
		can_use_shield = false
		player.shields.use_current()
	
	player.handle_jump()

func animate(player: Player, _delta: float):
	player.skin.handle_flip(player.input_direction.x)

	if player.is_rolling:
		player.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.rolling)
		player.skin.set_rolling_animation_speed(last_absolute_horizontal_speed)
	elif player.state_machine.last_state == "Spring" or player.state_machine.last_state == "Braking":
		player.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.walking)
