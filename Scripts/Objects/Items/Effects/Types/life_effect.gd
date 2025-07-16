extends ItemEffects
class_name LifeEffect

@export var life: int
@export var audio_jingle: AudioStream = preload("uid://coubjlbufx4sf")

func execute(_player: Player) -> void:
	EventBus.emit_signal("add_life", life)
	AudioManager.play_sfx(audio_jingle)
