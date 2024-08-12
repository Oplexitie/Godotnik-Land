extends PlayerState
class_name RegularPlayerState

func enter(player: Player):
	player.set_bounds(0)

func step(player: Player, delta: float):
	player.handle_fall()
	player.handle_gravity(delta)
	player.handle_jump()
	player.handle_slope(delta)
	player.handle_acceleration(delta)
	player.handle_friction(delta)

	if player.is_grounded():
		if player.input_dot_velocity < 0 and abs(player.velocity.x) >= player.current_stats.min_speed_to_brake:
			player.state_machine.change_state("Braking")
		if !abs(player.input_direction.x):
			if player.input_direction.y < 0 and abs(player.velocity.x) > player.current_stats.min_speed_to_roll:
				player.state_machine.change_state("Rolling")
	else:
		player.state_machine.change_state("Air")

func animate(player: Player, _delta: float):
	var absolute_speed: float = abs(player.velocity.x)
	
	player.skin.handle_flip(player.input_direction.x)
	player.skin.set_regular_animation_speed(absolute_speed)
	
	if absolute_speed >= 0.3:
		player.skin.set_running_animation_state(absolute_speed)
	elif !abs(player.input_direction.x) and player.absolute_ground_angle < GoUtils.SHALLOW_ANGLE:
		player.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.idle)
		
		var is_left: bool = player.skin.flip_h
		if !player.isnt_grounded_center: return
		
		if player.isnt_grounded_right:
			if is_left:
				player.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.balance_back)
			else:
				player.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.balance_front)
		elif player.isnt_grounded_left:
			if !is_left:
				player.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.balance_back)
			else:
				player.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.balance_front)
	else:
		player.skin.set_running_animation_state(absolute_speed)
	
	if player.is_pushing and player.absolute_ground_angle < GoUtils.SHALLOW_ANGLE:
		player.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.push)
