extends Panel

@export var parentControl:Control

@export var item:MaterialData = null
@export var amount:int = 1

@onready var border = $Border
@onready var item_texture = $Border/ItemTexture
@onready var label = $Label

var dragOffset: Vector2
var isMousePressed:bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if item:
		item_texture.texture = item.texture
		item_texture.visible = true
		label.visible = true
		label.text = str(amount)
	else:
		item_texture.visible = false
		label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_item_texture_gui_input(event):
	pass # Replace with function body.
