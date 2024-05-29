class_name Door
extends Node2D

@export var roomID:int = 0
@export var roomNumber:int = 0
@export var prevRoomNumber:int = 0
@export_enum("UP","RIGHT","LEFT","DOWN") var orientation:String
@export var fadeOut:TextureRect
@export var flag:Sprite2D

signal OnDoorEntered(roomNumber,roomID,prevRoomNumber)

func _on_area_2d_body_entered(body):
	if fadeOut:
		var tween = get_tree().create_tween()
		tween.tween_property(fadeOut,"modulate:a",1,0.5)
	OnDoorEntered.emit(roomNumber,roomID,prevRoomNumber)
	
