extends Node2D
class_name Shield

@export var invincible: bool = true
@export var ring_protection: bool = true

@export var action_audio: AudioStream

var active: bool
var shield_user: Player

func activate(player) -> void:
	if not active:
		active = true
		shield_user = player
		on_activate()

func deactivate() -> void:
	if active:
		active = false
		on_deactivate()

func action() -> void:
	if active:
		if action_audio:
			AudioManager.play_sfx(action_audio)
		on_action()

func on_activate() -> void:
	pass

func on_deactivate() -> void:
	pass

func on_action() -> void:
	pass

func cancel_action() -> void:
	pass
