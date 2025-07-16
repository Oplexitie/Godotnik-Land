extends ItemEffects
class_name ScoreEffect

@export var score: int

func execute(_player: Player) -> void:
	EventBus.emit_signal("add_score", score)
