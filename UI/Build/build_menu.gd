extends Control

@export_category("Control Setting")
@export var parentUI:Control
@export var inventoryHandler:InventoryHandler
@export var player:Player

@onready var timer = $Timer
@onready var description_board = $DescriptionBoard

var isDragging:bool = false

var atlasCoord:Vector2i = Vector2i(-1,-1)
var isInMenu:bool = false
var buildingName:String = "default"
var texture:Texture2D
var description:String
var instance:PackedScene

func _ready():
	await get_tree().create_timer(0.5).timeout
	inventoryHandler.init(player)


func _on_timer_timeout():
	description_board.visible = false
