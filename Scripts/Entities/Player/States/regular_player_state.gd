extends State

func enter(player: Node) -> void:
	player.set_bounds(0)

func step(player: Node, delta: float) -> void:
	player.handle_fall()
	player.handle_gravity(delta)
	player.handle_jump()
	player.handle_slope(delta)
	player.handle_acceleration(delta)
	player.handle_friction(delta)
	
	if player.is_grounded():
		if player.input_dot_velocity < 0 and abs(player.velocity.x) >= player.current_stats.min_speed_to_brake:
			player.state_machine.change_state("Braking")
		
		if abs(player.input_direction.x):
			if player.absolute_ground_angle < GoUtils.SHALLOW_ANGLE:
				var is_on_wall_front: bool = player.is_on_wall_left if player.input_direction.x < 0 else player.is_on_wall_right
				player.is_pushing = is_on_wall_front
		else:
			player.is_pushing = false
			if player.input_direction.y < 0 and abs(player.velocity.x) > player.current_stats.min_speed_to_roll:
				player.state_machine.change_state("Rolling")
	else:
		player.state_machine.change_state("Air")

func animate(player: Node, _delta: float) -> void:
	var absolute_speed: float = abs(player.velocity.x)
	
	player.skin.handle_flip(player.input_direction.x)
	player.skin.set_regular_animation_speed(absolute_speed)
	
	if absolute_speed >= 0.3:
		player.skin.set_running_animation_state(absolute_speed)
	else:
		player.skin.set_animation_state(player.skin.animation_states.idle)
		set_balance_animation_state(player)
		
		if player.is_pushing:
			player.skin.set_animation_state(player.skin.animation_states.push)

func set_balance_animation_state(player: Node) -> void:
		if player.is_grounded_center: return
		var is_facing_left: bool = player.skin.flip_h
		var is_grounded_front: bool = player.is_grounded_left if is_facing_left else player.is_grounded_right

		if not is_grounded_front:
			player.skin.set_animation_state(player.skin.animation_states.balance_front)
		else:
			player.skin.set_animation_state(player.skin.animation_states.balance_back)
