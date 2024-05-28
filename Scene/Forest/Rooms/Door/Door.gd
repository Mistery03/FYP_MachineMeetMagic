class_name Door
extends Node2D

@export var roomID:int = 0
@export var roomNumber:int = 0
@export_enum("UP","RIGHT","LEFT","DOWN") var orientation:String

signal OnDoorEntered(roomNumber,roomID,doorOrientation)

func _on_area_2d_body_entered(body):
	OnDoorEntered.emit(roomNumber,roomID,orientation)
	
