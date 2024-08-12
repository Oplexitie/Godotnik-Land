extends Shield

@onready var shield_sprite: Sprite2D = $ShieldSprite
@onready var shield_animation_player: AnimationPlayer = $ShieldSprite/AnimationPlayer

func on_activate():
	shield_sprite.visible = true
	shield_animation_player.play("default")

func on_deactivate():
	shield_sprite.visible = false
	shield_animation_player.stop()
