extends State

func enter(player: Node) -> void:
	AudioManager.play_sfx(player.sfx.brake)

func step(player: Node, delta: float) -> void:
	player.handle_fall()
	player.handle_gravity(delta)
	player.handle_jump()
	player.handle_deceleration(delta)
	
	if player.is_grounded():
		if player.input_dot_velocity >= 0:
			player.state_machine.change_state("Regular")
		elif player.input_direction.y < 0:
			player.state_machine.change_state("Rolling")
	else:
		if player.input_dot_velocity >= 0 or player.is_jumping:
			player.state_machine.change_state("Air")

func animate(player: Node, _delta: float) -> void:
	player.skin.set_animation_speed(1)
	player.skin.handle_flip(player.velocity.x)
	player.skin.set_animation_state(player.skin.animation_states.skidding)
