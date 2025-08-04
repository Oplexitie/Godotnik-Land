extends Node
class_name StateMachine

@export var initial_state: String = "Regular"

var states: Dictionary[String,State]
var current_state: String
var last_state: String

@onready var parent: Node = get_parent()

func initialize() -> void:
	initialize_states()
	change_state(initial_state)

func initialize_states() -> void:
	for state in get_children():
		states[state.name] = state

func change_state(to: String) -> void:
	if current_state:
		states[current_state].exit(parent)
	
	last_state = current_state
	current_state = to
	states[current_state].enter(parent)

func update_state(delta: float) -> void:
	if current_state:
		states[current_state].step(parent, delta)

func animate_state(delta: float) -> void:
	if current_state:
		states[current_state].animate(parent, delta)
