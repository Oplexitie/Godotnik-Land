extends Object
class_name GoUtils

const SHALLOW_ANGLE: int = 23
const HALF_STEEP_ANGLE: int = 45

static func get_angle_from(normal: Vector2) -> float:
	var radians: float = normal.angle_to(Vector2.UP)
	return -rad_to_deg(radians)

static func get_radian_from(normal: Vector2) -> float:
	var radians: float = normal.angle_to(Vector2.UP)
	return -radians

static func ground_to_global_velocity(velocity, normal) -> Vector2:
	var x_speed: float = velocity.x * -normal.y + velocity.y * -normal.x
	var y_speed: float = velocity.x * normal.x - velocity.y * normal.y
	return Vector2(x_speed, y_speed)

static func global_to_ground_velocity(velocity, normal) -> Vector2:
	var x_speed: float = velocity.x
	var angle: float = abs(get_angle_from(normal))
	
	if angle > SHALLOW_ANGLE and abs(x_speed) < velocity.y:
		var direction: float = sign(normal.x)
		
		if angle < HALF_STEEP_ANGLE:
			x_speed = velocity.y * 0.5 * direction
		else:
			x_speed = velocity.y * direction
	
	return Vector2(x_speed, 0)
