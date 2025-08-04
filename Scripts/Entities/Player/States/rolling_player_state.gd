extends State

func enter(player: Node) -> void:
	player.skin.rotation = 0
	player.is_rolling = true
	AudioManager.play_sfx(player.sfx.spin)
	player.set_bounds(1)

func step(player: Node, delta: float) -> void:
	player.handle_fall()
	player.handle_gravity(delta)
	player.handle_jump()
	player.handle_slope(delta)
	player.handle_deceleration(delta)
	player.handle_friction(delta)
	
	if player.is_grounded():
		if abs(player.velocity.x) < player.current_stats.unroll_speed:
			player.is_rolling = false
			player.state_machine.change_state("Regular")
	else:
		player.state_machine.change_state("Air")

func animate(player: Node, _delta: float) -> void:
	player.skin.set_animation_state(player.skin.animation_states.rolling)
	player.skin.set_rolling_animation_speed(abs(player.velocity.x))
