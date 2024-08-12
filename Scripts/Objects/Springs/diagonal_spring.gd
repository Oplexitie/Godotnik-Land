extends Node2D
class_name DiagonalSpring

@export var power: float = 400
@export_enum("Upward", "Downward") var vertical: int
@export_enum("Left", "Right") var horizontal: int
@export var spring_audio: AudioStream

@onready var animation_tree: AnimationTree = $Sprite/AnimationTree

func activate():
	AudioManager.play_sfx(spring_audio)
	animation_tree.set("parameters/state/request", 1)

func apply_force(player: Player):
	var horizontal_sign: int = 1 if horizontal else -1
	var vertical_sign: float = 1.0 if vertical else -1.2
	var direction: Vector2 = (position - player.position).normalized()
	
	if sign(direction.y) != vertical_sign:
		player.state_machine.change_state("Spring")
		player.velocity = Vector2(power * horizontal_sign, power * vertical_sign)
		activate()

func _on_SolidObject_player_right_wall_collision(player):
	if vertical:
		if player.position.y-position.y > -10:
			apply_force(player)
	else:
		if player.position.y-position.y < -10:
			apply_force(player)

func _on_SolidObject_player_left_wall_collision(player):
	if vertical:
		if player.position.y-position.y > -10:
			apply_force(player)
	else:
		if player.position.y-position.y < -10:
			apply_force(player)

func _on_SolidObject_player_ground_collision(player):
	if horizontal:
		if player.position.x-position.x > 0:
			apply_force(player)
	else:
		if player.position.x-position.x < 0:
			apply_force(player)

func _on_SolidObject_player_ceiling_collision(player):
	if horizontal:
		if player.position.x-position.x > 0:
			apply_force(player)
	else:
		if player.position.x-position.x < 0:
			apply_force(player)
