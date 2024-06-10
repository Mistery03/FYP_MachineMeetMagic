extends Panel
@onready var border = $Border
@onready var item_texture = $Border/ItemTexture
@onready var label = $Label

@export var item:MaterialData
@export var materialAmount:int

var inventoryHandler:Control
var dragOffset: Vector2

var amount:int = 0

var original_global_position:Vector2
var original_label_global_position:Vector2


func _process(delta):
	if item:
		item_texture.texture = item.texture
		item_texture.visible = true
		label.visible = true
		amount = clamp(amount,0,99)
		label.text = str(amount)
	else:
		item_texture.visible = false
		label.visible = false
	
	#if !inventoryHandler.parentControl.isDragging:
		#if inventoryHandler.currSlot:
			#inventoryHandler.currSlot.item_texture.global_position = inventoryHandler.currSlot.original_global_position
			#inventoryHandler.currSlot.label.global_position = inventoryHandler.currSlot.original_label_global_position

func _on_item_texture_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				inventoryHandler.parentControl.isDragging = true
				dragOffset = get_global_mouse_position() - get_global_position()
				item_texture.set_z_index(100)
				label.set_z_index(100)
				inventoryHandler.currSlot = self
				inventoryHandler.currSlot.original_global_position = border.global_position 
				inventoryHandler.currSlot.original_label_global_position =border.global_position + Vector2(70,50)

			else:
				if inventoryHandler.currSlot:	
					inventoryHandler.parentControl.prevSlot = self
					inventoryHandler.parentControl.isDragging= false
					item_texture.set_z_index(1)
					var gridPos = Vector2i(get_global_mouse_position()/custom_minimum_size)
					#emit_signal("dropped", inventoryHandler.currSlot, item, amount, gridPos)
					#inventoryHandler.currSlot.item_texture.global_position =  inventoryHandler.currSlot.border.global_position + Vector2(10,10)
					#inventoryHandler.currSlot.label.global_position = inventoryHandler.currSlot.border.global_position + Vector2(75,75)

	elif event is InputEventMouseMotion and inventoryHandler.parentControl.isDragging:
		item_texture.set_global_position(get_global_mouse_position() - dragOffset)
		label.set_global_position(get_global_mouse_position() - dragOffset + Vector2(75,70))
