extends Shield

@export var horizontal_force: float = 480
@export var attacking_sprite_offset: float = -12

@onready var shield_sprite: Sprite2D = $ShieldSprite
@onready var attacking_sprite: Sprite2D = $AttackingSprite

@onready var shield_animation_player: AnimationPlayer = $ShieldSprite/AnimationPlayer
@onready var attacking_animation_player: AnimationPlayer = $AttackingSprite/AnimationPlayer

func on_activate() -> void:
	shield_user.ground_enter.connect(on_user_ground_enter)
	set_attacking(false)

func on_deactivate() -> void:
	shield_user.ground_enter.disconnect(on_user_ground_enter)
	shield_sprite.visible = false
	attacking_sprite.visible = false
	shield_animation_player.stop()
	attacking_animation_player.stop()

func on_action() -> void:
	var direction = -1 if shield_user.skin.flip_h else 1
	shield_user.velocity.x = horizontal_force * direction
	shield_user.velocity.y = 0
	attacking_sprite.offset.x = attacking_sprite_offset * direction
	attacking_sprite.flip_h = shield_user.skin.flip_h
	set_attacking(true)

func set_attacking(value: bool) -> void:
	attacking_sprite.visible = value
	shield_sprite.visible = not value
	
	if value:
		shield_animation_player.stop()
		attacking_animation_player.play("default")
	else:
		attacking_animation_player.stop()
		shield_animation_player.play("default")

func on_user_ground_enter() -> void:
	set_attacking(false)
