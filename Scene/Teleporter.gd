extends Node2D

var player:Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	print(body)
	if body is Player:
		player = body

func _on_area_2d_body_exited(body):
	if body is Player:
		player = null

func _input(event):
		if event is InputEventAction:
			if event.is_action_pressed("DRINKPOTION"):
				if player:
					print("test")


