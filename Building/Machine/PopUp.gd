extends TextureRect

@export var machineUI:Control
@export var isConnectedToTransportPipe:bool = false

@onready var item_texture = $ItemTexture
@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta)->void:
	if isConnectedToTransportPipe:
		return
		
	if machineUI.result_slot.item:
		visible = true
		item_texture.texture = machineUI.result_slot.item.texture
		label.text = str(machineUI.result_slot.amount)
	else:
		visible = false
		item_texture.texture = null
		label.text = str(0)
