extends Resource
class_name PlayerStats

const CONTROL_LOCK_DURATION: float = 0.5

@export var acceleration: float = 168.75
@export var deceleration: float = 1800
@export var friction: float = 168.75
@export var slope_factor: float = 450
@export var top_speed: float = 360
@export var dash_speed: float = 600
@export var min_speed_to_brake: float = 240

@export var min_speed_to_roll: float = 60
@export var unroll_speed: float = 30
@export var slope_roll_up: float = 281.25
@export var slope_roll_down: float = 1125
@export var roll_deceleration: float = 450
@export var roll_friction: float = 84.375

@export var air_acceleration: float = 337.5
@export var gravity: float = 787.5
@export var max_jump_height: float = 390
@export var min_jump_height: float = 240

@export var slide_angle: float = 45
@export var fall_angle: float = 90
@export var min_speed_to_fall: float = 150
