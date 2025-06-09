@tool
extends Resource
class_name NodePositionManager

func get_radial_position(ref_position: Vector2, m: int, n: int, depth: int=0) -> Vector2:
	var radius: int = 300
	var angle: float = (-PI / n) * m

	var x: float = ref_position.x + cos(angle) * radius
	var y: float = ref_position.y + sin(angle) * radius

	return Vector2(x, y)

func get_fan_position(ref_position: Vector2, m: int, n: int, depth: int=0) -> Vector2:
	var x: float = ref_position.x + depth * 300
	var y: float = ref_position.y + (m - n / 2) * 180 

	# x = parent.x + (M - N / 2) * 250
	# y = parent.y + depth * 300

	return Vector2(x, y)

func get_grid_position(ref_position: Vector2, m: int, n: int, depth: int=0) -> Vector2:
	var cols: int = ceil(sqrt(n))
	var row: int = floor(m / cols)
	var col: int = m % cols

	var x_spacing: float = 300.0
	var y_spacing: float = 250.0
	var extra_depth: float = row * depth * 100

	var x: float = ref_position.x + col * x_spacing
	var y: float = ref_position.y + row * y_spacing + extra_depth

	return Vector2(x, y)
