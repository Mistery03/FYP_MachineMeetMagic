class_name Door
extends Node2D

@export var roomID:int = 0


func _on_area_2d_body_entered(body):
	print(body)
