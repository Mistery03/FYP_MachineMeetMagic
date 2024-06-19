extends Control

@export var parentUI:Control

@onready var timer = $Timer
@onready var description_board = $DescriptionBoard

var atlasCoord:Vector2i = Vector2i(-1,-1)
var isInMenu:bool = false
var buildingName:String = "default"
var texture:Texture2D
var description:String
var instance:PackedScene


func _on_timer_timeout():
	description_board.visible = false
