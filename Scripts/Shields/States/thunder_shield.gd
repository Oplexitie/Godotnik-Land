extends Shield
class_name ThunderShield

@export var vertical_force: float = -330

@onready var shield_sprite: Sprite2D = $ShieldSprite
@onready var shield_animation_player: AnimationPlayer = $ShieldSprite/AnimationPlayer
@onready var particle: PackedScene = preload("res://Scenes/Particles/thundershield_sparks.tscn")
@onready var zone: Node2D = get_node("/root/Zone")

func on_activate():
	shield_sprite.visible = true
	shield_animation_player.play("default")

func on_deactivate():
	shield_sprite.visible = false
	shield_animation_player.stop()

func on_action():
	shield_user.velocity.y = vertical_force
	var sparks = particle.instantiate()
	sparks.global_position = shield_user.global_position
	zone.add_child(sparks)
	sparks.play()
