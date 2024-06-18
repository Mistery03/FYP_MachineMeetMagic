class_name IMoveComponent
extends Node

@export var rollTimer:Timer

@export var inputList:Dictionary={
	"MoveLeft":"",
	"MoveRight":"",
	"MoveForward":"",
	"MoveBackward":""
}

var axis:Vector2 = Vector2.ZERO

func get_movement_direction() -> Vector2:

	axis = Input.get_vector(inputList.find_key("MoveLeft").to_upper(), inputList.find_key("MoveRight").to_upper(),inputList.find_key("MoveForward").to_upper(), inputList.find_key("MoveBackward").to_upper())
	return axis.normalized()

func isDashing():
	return !rollTimer.is_stopped()
