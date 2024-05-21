extends Node3D

@export var number_of_shapes: int = 20
@export var min_size: float = 0.5
@export var max_size: float = 2.0
@export var position_range: Vector3 = Vector3(10, 10, 10)
@export var light_intensity_range: Vector2 = Vector2(0.5, 2.0) 
@export var light_color_range: Vector2 = Vector2(0.5, 1.0) 
@export var camera_speed: float = 5.0 

var config = {}

func _ready():
	load_config()
	randomize()
	var shapes_to_generate = config.get("number_of_shapes", number_of_shapes)
	var min_shape_size = config.get("min_size", min_size)
	var max_shape_size = config.get("max_size", max_size)
	var pos_range = config.get("position_range", {
		"x": [-position_range.x, position_range.x],
		"y": [-position_range.y, position_range.y],
		"z": [-position_range.z, position_range.z]
	})

	for _i in range(shapes_to_generate):
		var shape_instance = create_random_shape(min_shape_size, max_shape_size, pos_range)
		add_child(shape_instance)

func load_config():
	var file_path = "res://config.json"
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var config_data = file.get_as_text()
		var json_result = JSON.parse_string(config_data)
		config = json_result
		number_of_shapes = config.get("number_of_shapes", number_of_shapes)
		min_size = config.get("min_size", min_size)
		max_size = config.get("max_size", max_size)
		file.close()

func create_random_shape(min_shape_size: float, max_shape_size: float, pos_range: Dictionary):
	var shape_type = randi() % 2 # 0 for cube, 1 for sphere
	var mesh_instance = MeshInstance3D.new()
	if shape_type == 0:
		var cube_mesh = BoxMesh.new()
		mesh_instance.mesh = cube_mesh
	else:
		var sphere_mesh = SphereMesh.new()
		mesh_instance.mesh = sphere_mesh

	# Set a random scale
	var scale_vector = Vector3(rand_range(min_shape_size, max_shape_size), rand_range(min_shape_size, max_shape_size), rand_range(min_shape_size, max_shape_size))
	mesh_instance.scale = scale_vector

	# Set a random position
	var pos_x = rand_range(pos_range["x"][0], pos_range["x"][1])
	var pos_y = rand_range(pos_range["y"][0], pos_range["y"][1])
	var pos_z = rand_range(pos_range["z"][0], pos_range["z"][1])
	mesh_instance.transform.origin = Vector3(pos_x, pos_y, pos_z)

	return mesh_instance

func rand_range(min_value: float, max_value: float) -> float:
	return randf() * (max_value - min_value) + min_value

