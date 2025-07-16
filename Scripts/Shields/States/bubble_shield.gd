extends Shield

@export var down_force: float = 480
@export var max_bounce_force: float = 450
@export var min_bounce_force: float = 240

@onready var shield_sprite: Sprite2D = $ShieldSprite
@onready var effect_sprite: Sprite2D  = $EffectSprite

@onready var shield_animation_player: AnimationPlayer = $ShieldSprite/AnimationPlayer
@onready var effect_animation_player: AnimationPlayer = $EffectSprite/AnimationPlayer

var is_bouncing: bool = false

func on_activate() -> void:
	shield_user.ground_enter.connect(on_user_ground_enter)
	is_bouncing = false
	shield_sprite.visible = true
	effect_sprite.visible = true
	shield_animation_player.play("default")
	effect_animation_player.play("default")

func on_deactivate() -> void:
	shield_user.ground_enter.disconnect(on_user_ground_enter)
	shield_sprite.visible = false
	effect_sprite.visible = false
	shield_animation_player.stop()
	effect_animation_player.stop()

func on_action() -> void:
	shield_user.velocity.x /= 2
	shield_user.velocity.y += down_force
	
	is_bouncing = true
	effect_sprite.visible = false
	shield_animation_player.play("bounce")
	effect_animation_player.stop()

func on_user_ground_enter() -> void:
	if is_bouncing:
		AudioManager.play_sfx(action_audio)
		
		is_bouncing = false
		shield_user.is_jumping = true
		shield_user.is_rolling = true
		shield_animation_player.play("bounce_back")
		
		var ground_angle: float = GoUtils.get_radian_from(shield_user.ground_normal)
		var is_bounce_press: bool = Input.is_action_pressed("player_a")
		var bounce_force: float = max_bounce_force if is_bounce_press else min_bounce_force
		
		shield_user.velocity.x -= bounce_force * sin(ground_angle)
		shield_user.velocity.y -= bounce_force * cos(ground_angle)

func cancel_action() -> void:
	if is_bouncing:
		is_bouncing = false
		shield_animation_player.play("bounce_back")

func _on_bubble_bounce_finished(anim_name) -> void:
	if anim_name == "bounce_back":
		effect_sprite.visible = true
		effect_animation_player.play("default")
		shield_animation_player.play("default")
