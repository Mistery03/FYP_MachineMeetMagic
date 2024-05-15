extends Control

@export var player:Player
@export var isPotionAmountShown:bool
var atlasCoord:Vector2i = Vector2i(-1,-1)
var isInMenu:bool = false
var potionName:String = "default"
var texture:Texture2D
var description:String
@onready var description_board = $DescriptionBoard
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _unhandled_input(event):
	if event is InputEventKey:
		if event.is_action_pressed("EXIT"):
			visible = false


func _on_timer_timeout():
	description_board.visible = false
