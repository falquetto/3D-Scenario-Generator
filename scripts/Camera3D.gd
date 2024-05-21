extends Camera3D

@export var camera_maxspeed: float = 100.0
@export var camera_accel: float = 100.0

var config = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	load_config()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector3.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += camera_accel 
	if Input.is_action_pressed("move_left"):
		velocity.x -= camera_accel
	if Input.is_action_pressed("move_down"):
		velocity.y += camera_accel
	if Input.is_action_pressed("move_up"):
		velocity.y -= camera_accel
		
	position += velocity * delta


func load_config():
	var file_path = "res://config.json"
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var config_data = file.get_as_text()
		var json_result = JSON.parse_string(config_data)
		config = json_result
		camera_maxspeed = config.get("camera_maxspeed", camera_maxspeed)
		camera_accel = config.get("camera_accel", camera_accel)
		file.close()
