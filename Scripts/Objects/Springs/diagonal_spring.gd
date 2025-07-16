extends Node2D
class_name DiagonalSpring

@export var power: Vector2 = Vector2(400,480)
@export_enum("Upward:-1", "Downward:1") var vertical: int
@export_enum("Left:-1", "Right:1") var horizontal: int
@export var vertical_threshold: float = 10
@export var horizontal_threshold: float = 0
@export var spring_audio: AudioStream

@onready var animation_tree: AnimationTree = $Sprite/AnimationTree

func activate() -> void:
	AudioManager.play_sfx(spring_audio)
	animation_tree.set("parameters/state/request", 1)

func apply_force(player: Player) -> void:
	var direction: Vector2 = (position - player.position).normalized()
	
	if sign(direction.y) != vertical:
		player.state_machine.change_state("Spring")
		player.velocity = Vector2(power.x * horizontal, power.y * vertical)
		player.shields.cancel_current()
		activate()

func _on_SolidObject_player_ground_collision(player) -> void:
	# Calculates the x distance between player and spring (flips depending on spring direction)
	var x_dist_player_spring: float = (player.position.x - position.x) * horizontal
	if x_dist_player_spring > horizontal_threshold:
		apply_force(player)

func _on_SolidObject_player_wall_collision(player) -> void:
	# Calculates the y distance between player and spring (flips depending on spring direction)
	var y_dist_player_spring: float = (player.position.y - position.y) * vertical
	if y_dist_player_spring > vertical_threshold:
		apply_force(player)
