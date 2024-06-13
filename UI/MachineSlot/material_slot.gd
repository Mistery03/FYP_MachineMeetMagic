extends Panel

@export var parentControl:Control

@export var item:MaterialData = null
@export var amount:int = 1

@onready var border = $Border
@onready var item_texture = $Border/ItemTexture
@onready var label = $Label

var dragOffset: Vector2
var isMousePressed:bool = false

var scaledSlotSize 

var currSlot:Panel
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

	if !parentControl.isDragging:
		item_texture.global_position =  border.global_position 
		label.global_position = border.global_position + Vector2(80,60)

func _on_item_texture_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				parentControl.isDragging = true
				dragOffset = get_global_mouse_position() - get_global_position()
				item_texture.set_z_index(100)
				label.set_z_index(100)
				parentControl.currMaterialSlotItem = self
			
			else:
				parentControl.isDragging = false
				item_texture.set_z_index(1)
				label.set_z_index(1)
			
				#parentControl.currItemFromparentControl = null

					
	elif event is InputEventMouseMotion and parentControl.isDragging:
		item_texture.set_global_position(get_global_mouse_position() - dragOffset )
		label.set_global_position(get_global_mouse_position() - dragOffset + Vector2(75,70))
		
	if event.is_action_pressed("AUTOLOADINITEM"):
		isMousePressed = true
		
func getSlotPosition()->Vector2i:
	var gridSlotPos:Vector2i
	gridSlotPos = Vector2i(position/custom_minimum_size)
	return gridSlotPos
