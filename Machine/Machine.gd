class_name Machine
extends Node

var machine:Machine 
var next:Machine = null
var ray:RayCast3D # Called when the node enters the scene tree for the first time.



func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var viewport := get_viewport()
	var mouse_position := viewport.get_mouse_position()
	var camera := viewport.get_camera_3d()
	var origin := camera.project_ray_origin(mouse_position)
	var direction := camera.project_ray_normal(mouse_position)
	
	ray.target_position =camera.project_local_ray_normal(mouse_position)

	
	print("test")
		
