extends Panel

@export var parentControl:Control

@export var item:MaterialData = null
@export var amount:int = 1

@onready var border = $Border
@onready var item_texture = $Border/ItemTexture
@onready var label = $Label

var isMousePressed:bool = false

var scaledSlotSize 

# Called when the node enters the scene tree for the first time.
func _ready():
	scaledSlotSize = custom_minimum_size * scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if item:
		item_texture.texture = item.texture
		item_texture.visible = true
		label.visible = true
		label.text = str(amount)

	else:
		item_texture.visible = false
		label.visible = false

