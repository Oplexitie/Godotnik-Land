extends Shield

@onready var shield_sprite: Sprite2D = $ShieldSprite
@onready var shield_animation_player: AnimationPlayer = $ShieldSprite/AnimationPlayer
@onready var collision: CollisionShape2D = $Area2D/CollisionShape2D

func _ready() -> void:
	set_attacking(false)

func on_action() -> void:
	set_attacking(true)
	shield_animation_player.play("default")
	await shield_animation_player.animation_finished
	set_attacking(false)

func set_attacking(value: bool) -> void:
	invincible = value
	shield_sprite.visible = value
	collision.set_deferred("disabled", not value)
