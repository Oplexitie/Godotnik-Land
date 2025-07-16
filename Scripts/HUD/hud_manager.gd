extends Node
class_name HudManager

signal time_over

const TIME_LIMIT: int = 600

var score: int = 0
var rings: int = 0
var lives: int = 3

var time: float
var time_stoped: bool

@onready var gameplay_hud: HUD = $Gameplay_HUD

func _ready() -> void:
	initialize_signals()

func _process(delta):
	handle_time(delta)

func initialize_signals() -> void:
	EventBus.add_signal("add_score",add_score)
	EventBus.add_signal("add_ring",add_ring)
	EventBus.add_signal("add_life",add_life)

func handle_time(delta: float):
	if not time_stoped:
		var next_time: float = time + delta
		if (next_time < TIME_LIMIT):
			time += delta
		else:
			time_stoped = true
			emit_signal("time_over")

func add_score(amount = 1):
	if amount > 0:
		score += amount
		gameplay_hud.on_score_added(score)

func add_ring(amount = 1):
	if amount > 0:
		rings += amount
		gameplay_hud.on_ring_added(rings)

func add_life(amount = 1):
	if amount > 0:
		lives += amount
		gameplay_hud.on_life_added(lives)
