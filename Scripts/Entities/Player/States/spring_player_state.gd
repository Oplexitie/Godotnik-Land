extends State

func enter(player: Node) -> void:
	player.skin.rotation = 0
	player.is_jumping = false
	player.is_rolling = false
	player.set_bounds(0)

func step(player: Node, delta: float) -> void:
	player.handle_gravity(delta)
	player.handle_acceleration(delta)
	
	if player.is_grounded():
		player.state_machine.change_state("Regular")
	elif player.velocity.y > 0:
		player.state_machine.change_state("Air")

func animate(player: Node, _delta: float) -> void:
	player.skin.set_animation_speed(1.5)
	player.skin.handle_flip(player.input_direction.x)
	player.skin.set_animation_state(player.skin.animation_states.corkscrew)
