extends ItemEffects
class_name RingEffect

@export var ring: int
@export var audio_jingle: AudioStream = preload("uid://b2hbqs45s5des")

func execute(_player: Player) -> void:
	EventBus.emit_signal("add_ring", ring)
	AudioManager.play_sfx(audio_jingle)
