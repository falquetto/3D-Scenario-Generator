extends Node3D

@export var number_of_shapes: int = 20
@export var min_size: float = 0.5
@export var max_size: float = 2.0
@export var position_range: Vector3 = Vector3(10, 10, 10)
@export var min_intensity: float = 0.5
@export var max_intensity: float = 2.0
@export var camera_speed: float = 5.0 
@export var num_lights: int = 35

var textures: Array = []
var config = {}

func create_random_light():
	var light = OmniLight3D.new()  # Change this to DirectionalLight, SpotLight, etc., as needed
	light.light_color = Color(randf(), randf(), randf())
	light.light_energy = rand_range(min_intensity, max_intensity)
	var pos_x = rand_range(-position_range.x, position_range.x)
	var pos_y = rand_range(-position_range.y, position_range.y)
	var pos_z = rand_range(-position_range.z, position_range.z)
	light.transform.origin = Vector3(pos_x, pos_y, pos_z)  # Set the local translation

	return light

func load_textures():
	var texture_path = "res://textures/"
	var dir = DirAccess.open(texture_path)
	dir.list_dir_begin()  # Correct use to skip navigational links if required
	var file_name = dir.get_next()
	while file_name != "":
		if not (file_name == "." or file_name == ".."):  # Explicitly skipping navigational entries
			if file_name.ends_with(".png") or file_name.ends_with(".jpg"):  # Check for image files
				var texture = load(texture_path + file_name)
				if texture:
					textures.append(texture)
		file_name = dir.get_next()
	dir.list_dir_end()

func _ready():
	load_config()
	load_textures()
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
	
	for i in range(num_lights):
		var light = create_random_light()
		add_child(light)

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
	
	#set random texture
	if textures.size() > 0:
		var material = StandardMaterial3D.new()
		material.albedo_texture = textures[randi() % textures.size()]
		mesh_instance.material_override = material

	return mesh_instance

func rand_range(min_value: float, max_value: float) -> float:
	return randf() * (max_value - min_value) + min_value

