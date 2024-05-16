extends Node2D

var target_position = Vector2.ZERO
var speed = 300
# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target_position != position:
		var direction = (target_position - position).normalized()
		position += direction * speed * delta
		
		if position.distance_to(target_position) < 10:
			queue_free()
	  
