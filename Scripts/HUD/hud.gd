extends Node
class_name HUD

@onready var score_label: Label = $Display/Score
@onready var rings_label: Label = $Display/Rings
@onready var lifes_label: Label = $Lives/Counter

@onready var minutes_label: Label = $Display/Timer/Minutes
@onready var seconds_label: Label = $Display/Timer/Seconds
@onready var milliseconds_label: Label = $Display/Timer/Milliseconds

func _ready():
	connect_signals()
	initialize_labels()

func _process(_delta):
	var time: float = ScoreManager.time
	var minutes:int = int(time / 60)
	var seconds:int = int(time) % 60
	var milliseconds:int = int(time * 100) % 100
	
	minutes_label.text = str(minutes)
	seconds_label.text = "%02d" % seconds
	milliseconds_label.text = "%02d" % milliseconds

func connect_signals():
	ScoreManager.score_added.connect(on_score_added)
	ScoreManager.ring_added.connect(on_ring_added)
	ScoreManager.life_added.connect(on_life_added)

func initialize_labels():
	score_label.text = str(ScoreManager.score)
	rings_label.text = str(ScoreManager.rings)
	lifes_label.text = str(ScoreManager.lives)

func on_score_added(score: int):
	score_label.text = str(score)

func on_ring_added(rings: int):
	rings_label.text = str(rings)

func on_life_added(lifes: int):
	lifes_label.text = str(lifes)
