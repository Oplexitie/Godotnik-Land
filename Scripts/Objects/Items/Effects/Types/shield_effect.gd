extends ItemEffects
class_name ShieldEffect

@export_enum("BlueShield", "ThunderShield", "FlameShield", "BubbleShield") var shield_type: String
@export var audio_jingle: AudioStream

func execute(player: Player) -> void:
	player.shields.change(shield_type)
	AudioManager.play_sfx(audio_jingle)
