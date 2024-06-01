class_name Door
extends Node2D

@export var roomID:int = 0
@export var roomNumber:int = 0
@export var parent:Node2D
@export var flag:Sprite2D


signal OnDoorEntered

func _on_area_2d_body_entered(body):
	print("test")

		
	OnDoorEntered.emit()
	
