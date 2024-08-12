extends Node2D
class_name PlayerStateMachine

@export var initial_state: String = "Regular"

@onready var player: Player = get_parent()

@onready var states: Dictionary = {
	"Regular": $Regular,
	"Rolling": $Rolling,
	"Braking": $Braking,
	"Air": $Air,
	"Spring": $Spring
}

var current_state: String
var last_state: String

func initialize():
	change_state(initial_state)

func change_state(to: String):
	if current_state:
		states[current_state].exit(player)

	last_state = current_state
	current_state = to
	states[current_state].enter(player)

func update_state(delta: float):
	if current_state:
		states[current_state].step(player, delta)

func animate_state(delta: float):
	if current_state:
		states[current_state].animate(player, delta)
