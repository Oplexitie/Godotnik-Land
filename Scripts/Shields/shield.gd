extends Node2D
class_name Shield

@export var invincible: bool = true
@export var ring_protection: bool = true

@export var action_audio: AudioStream

var active: bool
var shield_user: Player

func activate(player):
	if not active:
		active = true
		shield_user = player
		on_activate()

func deactivate():
	if active:
		active = false
		on_deactivate()

func action():
	if active:
		if action_audio:
			AudioManager.play_sfx(action_audio)
		on_action()

func on_activate():
	pass

func on_deactivate():
	pass

func on_action():
	pass

func cancel_action():
	pass
