extends Shield

@export var down_force: float = 480
@export var bounce_force: float = 450
@export var min_bounce_force: float = 240

@onready var shield_sprite: Sprite2D = $ShieldSprite
@onready var effect_sprite: Sprite2D  = $EffectSprite

@onready var shield_animation_player: AnimationPlayer = $ShieldSprite/AnimationPlayer
@onready var effect_animation_player: AnimationPlayer = $EffectSprite/AnimationPlayer

var is_bouncing: bool = false

func on_activate():
	shield_animation_player.play("default")
	effect_animation_player.play("default")
	shield_user.ground_enter.connect(on_user_ground_enter)
	is_bouncing = false
	shield_sprite.visible = true
	effect_sprite.visible = true

func on_deactivate():
	shield_user.ground_enter.disconnect(on_user_ground_enter)
	shield_sprite.visible = false
	effect_sprite.visible = false
	shield_animation_player.stop()
	effect_animation_player.stop()

func on_action():
	shield_user.velocity.x /= 2
	shield_user.velocity.y += down_force
	
	shield_animation_player.play("bounce")
	is_bouncing = true
	effect_sprite.visible = false

func on_user_ground_enter():
	if is_bouncing:
		shield_animation_player.play("bounce_back")
		is_bouncing = false
		AudioManager.play_sfx(action_audio)
		shield_user.is_jumping = true
		shield_user.is_rolling = true
		
		var ground_angle: float = GoUtils.get_radian_from(shield_user.ground_normal)
		
		if Input.is_action_pressed("player_a"):
			shield_user.velocity.x -= bounce_force * sin(ground_angle)
			shield_user.velocity.y -= bounce_force * cos(ground_angle)
		else:
			shield_user.velocity.x -= min_bounce_force * sin(ground_angle)
			shield_user.velocity.y -= min_bounce_force * cos(ground_angle)

func cancel_action():
	if is_bouncing:
		shield_animation_player.play("bounce_back")
		is_bouncing = false

func _on_bubble_bounce_finished(anim_name):
	if anim_name == "bounce_back":
		effect_animation_player.stop()
		effect_sprite.visible = true
		effect_animation_player.play("default")
		shield_animation_player.play("default")
