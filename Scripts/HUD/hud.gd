extends Node
class_name HUD

@onready var score_label: Label = $Display/Score
@onready var rings_label: Label = $Display/Rings
@onready var lifes_label: Label = $Lives/Counter

@onready var minutes_label: Label = $Display/Timer/Minutes
@onready var seconds_label: Label = $Display/Timer/Seconds
@onready var milliseconds_label: Label = $Display/Timer/Milliseconds

@onready var hud_manager: HudManager = get_parent()

func _ready():
	initialize_labels()

func _process(_delta):
	var time: float = hud_manager.time
	var minutes:int = int(time / 60)
	var seconds:int = int(time) % 60
	var milliseconds:int = int(time * 100) % 100
	
	minutes_label.text = str(minutes)
	seconds_label.text = "%02d" % seconds
	milliseconds_label.text = "%02d" % milliseconds

func initialize_labels():
	score_label.text = str(hud_manager.score)
	rings_label.text = str(hud_manager.rings)
	lifes_label.text = str(hud_manager.lives)

func on_score_added(score: int):
	score_label.text = str(score)

func on_ring_added(rings: int):
	rings_label.text = str(rings)

func on_life_added(lifes: int):
	lifes_label.text = str(lifes)
