extends Control

@export var player:Player
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _unhandled_input(event):
	if Input.is_action_just_pressed("EXIT"):
		player.isPressable = true
		visible = false
