extends Node2D
class_name ShieldsManager

@onready var shields: Dictionary = {
	"None": null,
	"InstaShield": $InstaShield,
	"BlueShield": $BlueShield,
	"ThunderShield": $ThunderShield,
	"FlameShield": $FlameShield,
	"BubbleShield": $BubbleShield
}

@onready var shield_user: Player = get_parent()
@onready var default_shield: String = "InstaShield"

var current_shield: Shield

func _ready() -> void:
	change(default_shield)

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
