extends Camera3D

@export var camera_maxspeed: float = 100.0
@export var camera_accel: float = 100.0

@export var mouse_sens = 0.3
@export var camera_anglev=0

var rot_x = 0
var rot_y = 0
var LOOKAROUND_SPEED  = 0.005

func _input(event):  		
	if event is InputEventMouseMotion and event.button_mask & 1:
		# modify accumulated mouse rotation
		rot_x += event.relative.x * LOOKAROUND_SPEED
		rot_y += event.relative.y * LOOKAROUND_SPEED
		transform.basis = Basis() # reset rotation
		rotate_object_local(Vector3(0, 1, 0), rot_x) # first rotate in Y
		rotate_object_local(Vector3(1, 0, 0), rot_y) # then rotate in X
		transform = transform.orthonormalized()


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
		velocity.y -= camera_accel
	if Input.is_action_pressed("move_up"):
		velocity.y += camera_accel
	if Input.is_action_pressed("move_foward"):
		velocity.z -= camera_accel
	if Input.is_action_pressed("move_backwad"):
		velocity.z += camera_accel
	position += transform.basis * velocity * delta


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
