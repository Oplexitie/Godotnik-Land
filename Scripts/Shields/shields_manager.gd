extends Node2D
class_name ShieldsManager

var current_shield: Shield

@onready var shields: Dictionary = {
	"None": null
}

@onready var shield_user: Player = get_parent()
@onready var default_shield: String = "InstaShield"

func _ready() -> void:
	initialize_shields()
	change(default_shield)

func initialize_shields() -> void:
	for shield in get_children():
		shields[shield.name] = shield

func change(to: String) -> void:
	if current_shield:
		current_shield.deactivate()
	
	current_shield = shields[to]
	current_shield.activate(shield_user)

func change_to_default() -> void:
	change(default_shield)

func use_current() -> void:
	if current_shield:
		current_shield.action()

func cancel_current() -> void:
	current_shield.cancel_action()
