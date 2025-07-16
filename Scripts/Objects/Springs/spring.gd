extends Node2D
class_name Spring

const CONTROL_LOCK_DURATION: float = 0.25

@export var power: float = 600
@export_enum("Vertical", "Horizontal") var type: int
@export var spring_audio: AudioStream

@onready var animation_tree: AnimationTree = $Sprite/AnimationTree

func activate() -> void:
	AudioManager.play_sfx(spring_audio)
	animation_tree.set("parameters/state/request", 1)

func apply_vertical_force(player: Player, direction: int) -> void:
	player.velocity.y = power * -direction
	activate()

func apply_horizontal_force(player: Player, direction: int) -> void:
	player.lock_controls(CONTROL_LOCK_DURATION)
	player.skin.handle_flip(direction)
	player.velocity.x = power * direction
	activate()

func _on_SolidObject_player_right_wall_collision(player: Player) -> void:
	if type == 1:
		apply_horizontal_force(player, -1)
	else:
		if abs(player.rotation_degrees) == 90:
			apply_horizontal_force(player, -1)

func _on_SolidObject_player_left_wall_collision(player: Player) -> void:
	if type == 1:
		apply_horizontal_force(player, 1)
	else:
		if abs(player.rotation_degrees) == 90:
			apply_horizontal_force(player, 1)

func _on_SolidObject_player_ground_collision(player: Player) -> void:
	if type == 0 and player.velocity.y >= 0:
		player.state_machine.change_state("Spring")
		player.shields.cancel_current()
		apply_vertical_force(player, 1)

func _on_SolidObject_player_ceiling_collision(player: Player) -> void:
	if type == 0 and player.velocity.y <= 0:
		apply_vertical_force(player, -1)
