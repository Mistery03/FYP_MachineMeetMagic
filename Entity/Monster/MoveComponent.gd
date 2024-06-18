class_name IMovement
extends Node

func getRandomDirection():
	var directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
	return directions[randi() % directions.size()]
